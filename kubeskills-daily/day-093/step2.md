# Step 2 — Identify the Root Cause

The quota is exhausted, but nothing on the surface explains why. Trace the failure from Deployment to ReplicaSet to the API server rejection — and then find the hidden consumer that nobody on the team accounted for.

## Start at the Top: Inspect the ReplicaSet Events

When a Deployment can't scale, the Deployment controller delegates pod creation to a ReplicaSet. The ReplicaSet is where the API server rejection appears:

```bash
kubectl describe replicaset -n team-alpha -l app=api-server
```{{exec}}

Scroll to the `Events` section at the bottom. You will see something like:

```text
Warning  FailedCreate  ...  Error creating: pods "api-server-..." is forbidden:
  exceeded quota: team-alpha-quota, requested: limits.memory=128Mi,pods=1,
  requests.memory=64Mi, used: limits.memory=1Gi,pods=6,requests.memory=512Mi,
  limited: limits.memory=1Gi,pods=6,requests.memory=512Mi
```

Three quota dimensions are simultaneously exhausted: `pods`, `requests.memory`, and `limits.memory`. The API server rejected the pod at admission — no pod object was ever created, not even a Pending one. That explains why there are no Pending pods to find.

## Inspect the Quota: Used vs Hard

Confirm the exact numbers:

```bash
kubectl describe resourcequota team-alpha-quota -n team-alpha
```{{exec}}

```text
Name:            team-alpha-quota
Namespace:       team-alpha
Resource         Used    Hard
--------         ----    ----
limits.cpu       1200m   2000m
limits.memory    1Gi     1Gi
pods             6       6
requests.cpu     900m    1000m
requests.memory  512Mi   512Mi
```

`pods`, `requests.memory`, and `limits.memory` are all at 100% utilization. Yet the running workloads appear to be only `frontend` (2 replicas) and `cache` (2 replicas) plus 2 `api-server` pods — six total. The numbers look right. But do the math: is the `cache` deployment actually consuming what the team thinks it is?

## Find the Hidden Consumer: LimitRange Injection

The `cache` deployment was applied with no `resources` block at all. Check what the running cache pods are actually consuming:

```bash
kubectl get pod -n team-alpha -l app=cache \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{.spec.containers[0].resources}{"\n\n"}{end}'
```{{exec}}

```text
cache-7d9f5c-abc12
{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}

cache-7d9f5c-def34
{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}
```

The cache pods have resource limits and requests — even though the Deployment spec specified none. This is **LimitRange injection**: when a pod spec has no resource block, the LimitRange fills in `defaultRequest` and `default` values at admission time, before the pod is stored in etcd.

Confirm what the LimitRange injects:

```bash
kubectl describe limitrange team-alpha-limits -n team-alpha
```{{exec}}

```text
Name:       team-alpha-limits
Namespace:  team-alpha
Type        Resource  Min  Max   Default Request  Default Limit
----        --------  ---  ---   ---------------  -------------
Container   cpu       -    500m  100m             200m
Container   memory    -    256Mi 64Mi             128Mi
```

Every container admitted to this namespace without explicit resources is silently assigned `requests: {cpu: 100m, memory: 64Mi}` and `limits: {cpu: 200m, memory: 128Mi}`. The cache team said it "uses almost nothing," but the LimitRange assigned it the same defaults as any other container.

Compare the Deployment spec to what's running:

```bash
kubectl get deployment cache -n team-alpha \
  -o jsonpath='{.spec.template.spec.containers[0].resources}{"\n"}'
```{{exec}}

Output: `{}` — the Deployment spec has an empty resources block.

```bash
kubectl get pod -n team-alpha -l app=cache -o name | head -1 | \
  xargs kubectl get -n team-alpha \
  -o jsonpath='{.spec.containers[0].resources}{"\n"}'
```{{exec}}

The running pod has populated resources. The mismatch between Deployment spec (`{}`) and the pod spec (resources injected) is the fingerprint of LimitRange injection.

## Do the Quota Math

Now reconstruct exactly where the quota went:

| Workload           | Replicas | requests.cpu | requests.memory | limits.memory | pods |
|--------------------|----------|-------------|-----------------|---------------|------|
| frontend           | 2        | 2 × 200m = 400m | 2 × 128Mi = 256Mi | 2 × 256Mi = 512Mi | 2 |
| cache (injected)   | 2        | 2 × 100m = 200m | 2 × 64Mi = 128Mi | 2 × 128Mi = 256Mi | 2 |
| **Subtotal**       | **4**    | **600m**    | **384Mi**       | **768Mi**     | **4** |
| api-server pod 1   | +1       | 750m        | 448Mi           | 896Mi         | 5 |
| api-server pod 2   | +1       | 900m        | 512Mi           | 1024Mi = 1Gi  | 6 |
| api-server pod 3   | +1       | **1050m** ✗ | **576Mi** ✗     | **1152Mi** ✗  | **7** ✗ |

After 2 `api-server` pods are scheduled:

- `pods` hits **6/6** — the hard limit
- `requests.memory` hits **512Mi/512Mi** — the hard limit
- `limits.memory` hits **1Gi/1Gi** — the hard limit

A third `api-server` pod violates all three simultaneously. The API server rejects the admission request before any scheduling decision is made. No pod object is ever written to etcd. That is why the Deployment shows DESIRED=4 but READY=2 with nothing Pending.

## Root Cause Summary

| Resource         | Used  | Hard  | Headroom | Blocked? |
|------------------|-------|-------|----------|----------|
| pods             | 6     | 6     | 0        | Yes |
| requests.cpu     | 900m  | 1000m | 100m     | Not yet |
| requests.memory  | 512Mi | 512Mi | 0        | Yes |
| limits.cpu       | 1200m | 2000m | 800m     | No |
| limits.memory    | 1Gi   | 1Gi   | 0        | Yes |

**Root cause:** The `cache` deployment applied with no resource block. The LimitRange silently injected `requests.cpu: 100m, requests.memory: 64Mi` and `limits.memory: 128Mi` per container. This invisible consumption left no headroom for 4 `api-server` replicas. Only 2 of 4 api-server pods could be admitted before the namespace hit three hard limits simultaneously.
