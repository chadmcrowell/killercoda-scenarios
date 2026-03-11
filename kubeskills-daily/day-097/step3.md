# Step 3 — Apply the Fix

The deployment's affinity rule specifies `nvidia-v100` but the node is labeled `nvidia-t4`. The correct fix is to update the manifest to match the actual hardware label. A second option shows how to add a label to the node if the label itself was wrong. A third option demonstrates softening the affinity to `preferred` for workloads that are not hardware-specific.

## Option A — Fix the Affinity Rule in the Deployment

Patch the deployment to replace `nvidia-v100` with `nvidia-t4`:

```bash
kubectl patch deployment batch-processor -n analytics \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/affinity/nodeAffinity/requiredDuringSchedulingIgnoredDuringExecution/nodeSelectorTerms/0/matchExpressions/0/values/0", "value": "nvidia-t4"}]'
```{{exec}}

Confirm the patch was applied:

```bash
kubectl get deployment batch-processor -n analytics \
  -o jsonpath='{.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0]}'
```{{exec}}

```text
{"key":"accelerator","operator":"In","values":["nvidia-t4"]}
```

The patch triggers a rolling update. Watch the pods transition from `Pending` to `Running`:

```bash
kubectl get pods -n analytics -w
```{{exec}}

```text
NAME                               READY   STATUS    RESTARTS   AGE
batch-processor-7d9f8c6b5-4xkpq    0/1     Pending   0          4m
batch-processor-7d9f8c6b5-9lbzv    0/1     Pending   0          4m
batch-processor-7d9f8c6b5-mnpq2    0/1     Pending   0          4m
batch-processor-6c8f9d7b4-xj2nq    0/1     ContainerCreating   0   3s
batch-processor-6c8f9d7b4-xj2nq    1/1     Running   0          5s
batch-processor-6c8f9d7b4-p4lzw    1/1     Running   0          7s
batch-processor-6c8f9d7b4-rk9vm    1/1     Running   0          9s
```

Press `Ctrl+C` when all three new replicas show `Running`. The old `Pending` pods are terminated as the rolling update completes. Skip to **Final Verification** below.

---

## Option B — Correct the Node Label

Use this path if the node was mislabeled and the manifest is correct. If node01 actually has V100 hardware but was labeled with the wrong value:

```bash
kubectl label node node01 accelerator=nvidia-v100 --overwrite
```{{exec}}

Verify the updated label:

```bash
kubectl get node node01 --show-labels | tr ',' '\n' | grep accelerator
```{{exec}}

```text
accelerator=nvidia-v100
```

The scheduler retries pending pods automatically. Watch them start:

```bash
kubectl get pods -n analytics -w
```{{exec}}

Press `Ctrl+C` when all pods show `Running`.

> **Note:** Relabeling nodes to match a bad manifest is the wrong approach in most cases — it misrepresents your cluster topology and breaks other workloads relying on accurate labels. Fix the manifest unless you are certain the original label was the error.

---

## Option C — Soften the Affinity to `preferred`

If the GPU requirement is a preference rather than a hard constraint — for instance, this workload runs faster on GPU nodes but can run anywhere — switch from `required` to `preferred`. Apply this version of the deployment (assumes Option A's label is already correct):

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: batch-processor
  namespace: analytics
spec:
  replicas: 3
  selector:
    matchLabels:
      app: batch-processor
  template:
    metadata:
      labels:
        app: batch-processor
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: accelerator
                operator: In
                values:
                - nvidia-t4
      containers:
      - name: processor
        image: busybox:stable
        command: ["sh", "-c", "echo Processing batch job && sleep 3600"]
        resources:
          requests:
            cpu: "100m"
            memory: "128Mi"
EOF
```{{exec}}

With `preferred`, the scheduler still tries to land pods on nodes with `accelerator=nvidia-t4`, but if no such node is available it falls back to any schedulable node instead of leaving the pods `Pending`.

---

## Final Verification

Confirm all three replicas are running:

```bash
kubectl get pods -n analytics -o wide
```{{exec}}

```text
NAME                               READY   STATUS    RESTARTS   AGE   NODE
batch-processor-6c8f9d7b4-xj2nq    1/1     Running   0          45s   node01
batch-processor-6c8f9d7b4-p4lzw    1/1     Running   0          43s   node01
batch-processor-6c8f9d7b4-rk9vm    1/1     Running   0          41s   node01
```

All pods landed on `node01` — the node that carries the `accelerator` label. The controlplane is still excluded by its taint, which is the correct behavior.

Confirm the deployment is fully ready:

```bash
kubectl get deployment batch-processor -n analytics
```{{exec}}

```text
NAME               READY   UP-TO-DATE   AVAILABLE   DESIRED
batch-processor    3/3     3            3           3
```

`READY 3/3` — all replicas are running and the rollout is complete.

Verify that node01 actually has the label the affinity rule requires:

```bash
kubectl get node node01 -o jsonpath='{.metadata.labels.accelerator}'
```{{exec}}

```text
nvidia-t4
```

---

## Node Affinity Debugging Runbook

When pods are stuck in `Pending` and you suspect affinity:

```bash
# 1. Read the scheduler's rejection reason
kubectl describe pod -n <namespace> <pod-name> | grep -A 10 'Events:'

# 2. Show all node labels
kubectl get nodes --show-labels

# 3. Extract the affinity rules from the deployment
kubectl get deployment <name> -n <namespace> \
  -o jsonpath='{.spec.template.spec.affinity}' | python3 -m json.tool

# 4. Check if any node satisfies a specific label requirement
kubectl get nodes -l 'accelerator in (nvidia-t4,nvidia-v100)'

# 5. See the full affinity evaluation in the scheduler logs
kubectl logs -n kube-system -l component=kube-scheduler --tail=50 | grep <pod-name>
```

Key rules to remember:

- `requiredDuringSchedulingIgnoredDuringExecution` — hard constraint, pods stay `Pending` forever if no match
- `preferredDuringSchedulingIgnoredDuringExecution` — soft preference, pods fall back to any node if no match
- Node label values are an **exact string match** — `nvidia-t4` and `nvidia-T4` are different values
- `operator: In` requires the node label value to appear in the `values` list
- `operator: Exists` only checks for the key — the value does not matter
