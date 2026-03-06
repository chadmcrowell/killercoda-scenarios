# Step 3 — Apply the Fix

Two viable paths exist: increase the quota to accommodate the real workload, or reduce the resource footprint of the workload that is silently over-consuming. Under time pressure, the fastest safe fix is to patch the quota. The deeper fix is to give the cache deployment explicit resource requests that reflect what it actually needs.

## Option A — Patch the ResourceQuota

The quota was sized without accounting for LimitRange injection on the cache deployment. Adding the actual cache consumption (200m cpu req, 128Mi mem req, 256Mi mem limit) to the quota gives `api-server` the headroom it needs.

Calculate what the quota needs to be to fit all 4 api-server pods:

- `pods`: 2 (frontend) + 2 (cache) + 4 (api-server) = **8**
- `requests.cpu`: 400m + 200m + 4×150m = **1200m**
- `requests.memory`: 256Mi + 128Mi + 4×64Mi = **640Mi**
- `limits.cpu`: 800m + 400m + 4×300m = **2400m**
- `limits.memory`: 512Mi + 256Mi + 4×128Mi = **1280Mi**

Patch the quota to accommodate the full workload:

```bash
kubectl patch resourcequota team-alpha-quota -n team-alpha \
  --type=merge \
  -p '{
    "spec": {
      "hard": {
        "pods": "10",
        "requests.cpu": "1500m",
        "requests.memory": "700Mi",
        "limits.cpu": "3000m",
        "limits.memory": "1500Mi"
      }
    }
  }'
```{{exec}}

Verify the new quota values are applied:

```bash
kubectl describe resourcequota team-alpha-quota -n team-alpha
```{{exec}}

The `Hard` column now shows the updated limits with headroom for the full workload.

## Wait for the Deployment to Self-Heal

The Deployment controller retries failed pod creations automatically. Within a few seconds of the quota patch, the ReplicaSet will attempt to create the blocked pods again:

```bash
kubectl get deployments -n team-alpha -w
```{{exec}}

Press `Ctrl+C` when you see:

```text
NAME         READY   UP-TO-DATE   AVAILABLE
api-server   4/4     4            4
cache        2/2     2            2
frontend     2/2     2            2
```

`api-server` reaches its desired 4 replicas without any additional action. The Deployment controller, ReplicaSet controller, and scheduler work together to create the two missing pods now that quota admission will succeed.

Confirm all 8 pods are running:

```bash
kubectl get pods -n team-alpha
```{{exec}}

All 8 pods show `Running`. No pod was ever deleted or restarted — only the quota gate was opened.

Check the updated quota usage:

```bash
kubectl describe resourcequota team-alpha-quota -n team-alpha
```{{exec}}

`Used` reflects all 8 pods, and each dimension has headroom for additional workloads.

---

## Option B — Fix the Root Cause in the Cache Deployment

Patching the quota unblocks today's scale-out, but the underlying problem remains: the cache deployment has no explicit resource requests, so every future developer who looks at it will see `{}` and not know what it actually consumes. Add explicit requests that reflect what the LimitRange was injecting anyway:

```bash
kubectl patch deployment cache -n team-alpha \
  --type=strategic \
  -p '{
    "spec": {
      "template": {
        "spec": {
          "containers": [{
            "name": "cache",
            "resources": {
              "requests": {
                "cpu": "50m",
                "memory": "32Mi"
              },
              "limits": {
                "cpu": "100m",
                "memory": "64Mi"
              }
            }
          }]
        }
      }
    }
  }'
```{{exec}}

This sets requests that are lower than the LimitRange defaults, which is appropriate for a busybox sleep process. The deployment will roll out new pods with the explicit values, and quota usage will drop:

```bash
kubectl rollout status deployment/cache -n team-alpha
```{{exec}}

Check the new quota utilization after the cache rollout:

```bash
kubectl describe resourcequota team-alpha-quota -n team-alpha
```{{exec}}

With explicit lower requests on the cache deployment, the namespace has more headroom for the api-server to scale.

---

## Final Verification

Confirm all deployments are healthy and the ReplicaSet no longer shows FailedCreate events:

```bash
kubectl get deployments -n team-alpha
```{{exec}}

```bash
kubectl describe replicaset -n team-alpha -l app=api-server | tail -20
```{{exec}}

The Events section should be clean — no more `exceeded quota` warnings.

Run a quota audit to capture the final steady-state consumption:

```bash
kubectl describe resourcequota team-alpha-quota -n team-alpha
```{{exec}}

---

## Quota Debugging Runbook

When a Deployment is stuck below its desired replica count with no Pending pods:

```bash
# 1. Find the rejection event on the ReplicaSet
kubectl describe replicaset -n <namespace> -l app=<app-name>

# 2. See exactly which quota dimensions are exhausted
kubectl describe resourcequota -n <namespace>

# 3. Check if LimitRange is injecting resources into unspecified pods
kubectl describe limitrange -n <namespace>

# 4. Compare Deployment spec vs running pod spec to detect injection
kubectl get deployment <name> -n <ns> \
  -o jsonpath='{.spec.template.spec.containers[0].resources}'
kubectl get pod -n <ns> -l app=<name> -o name | head -1 | \
  xargs kubectl get -n <ns> \
  -o jsonpath='{.spec.containers[0].resources}'
```{{exec}}

Empty Deployment resources + populated pod resources = LimitRange injection. The gap between what teams declare and what actually runs is the most common source of unexpected quota exhaustion.
