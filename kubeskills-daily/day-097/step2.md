# Step 2 — Identify the Root Cause

The scheduler told you node01 didn't match the pod's node affinity. Now compare the labels present on the node against the labels the affinity rules require, and understand exactly why the match fails.

## List All Node Labels

Check what labels are currently on each node:

```bash
kubectl get nodes --show-labels
```{{exec}}

```text
NAME           STATUS   ROLES           AGE   VERSION   LABELS
controlplane   Ready    control-plane   25m   v1.29.0   beta.kubernetes.io/arch=amd64,...,node-role.kubernetes.io/control-plane=,...
node01         Ready    <none>          23m   v1.29.0   beta.kubernetes.io/arch=amd64,...,accelerator=nvidia-t4,...
```

node01 has the label `accelerator=nvidia-t4`. Describe node01 for a cleaner view of just its labels:

```bash
kubectl describe node node01 | grep -A 20 'Labels:'
```{{exec}}

```text
Labels:
  beta.kubernetes.io/arch=amd64
  beta.kubernetes.io/os=linux
  kubernetes.io/arch=amd64
  kubernetes.io/hostname=node01
  kubernetes.io/os=linux
  accelerator=nvidia-t4
```

The label `accelerator=nvidia-t4` is present. Now pull the affinity rules from the deployment to see what is actually being required:

```bash
kubectl get deployment batch-processor -n analytics \
  -o jsonpath='{.spec.template.spec.affinity}' | python3 -m json.tool
```{{exec}}

```text
{
    "nodeAffinity": {
        "requiredDuringSchedulingIgnoredDuringExecution": {
            "nodeSelectorTerms": [
                {
                    "matchExpressions": [
                        {
                            "key": "accelerator",
                            "operator": "In",
                            "values": [
                                "nvidia-v100"
                            ]
                        }
                    ]
                }
            ]
        }
    }
}
```

The affinity rule requires `accelerator In [nvidia-v100]`. The node has `accelerator=nvidia-t4`. These two values do not match — `nvidia-t4` is not in the list `[nvidia-v100]` — so the scheduler rejects node01 every time it evaluates this pod.

## Understand `requiredDuringSchedulingIgnoredDuringExecution`

The affinity type matters. This deployment uses the **required** form:

| Affinity Type | Scheduling Behavior | Running Pod Behavior |
| --- | --- | --- |
| `requiredDuringSchedulingIgnoredDuringExecution` | Pod will **not** be scheduled unless a matching node exists | Already-running pods are **not** evicted if labels change |
| `preferredDuringSchedulingIgnoredDuringExecution` | Scheduler **prefers** matching nodes but will fall back to any node | Already-running pods are **not** evicted if labels change |

Because `required` is set, the scheduler treats the affinity as a hard constraint. There is zero tolerance for a mismatch — the pod stays `Pending` forever rather than land on a node that doesn't match.

## Confirm the Mismatch

Side-by-side comparison:

| What the affinity requires | What node01 has | Match? |
| --- | --- | --- |
| `accelerator=nvidia-v100` | `accelerator=nvidia-t4` | No |

**Root cause:** The deployment was copied from a cluster provisioned with NVIDIA V100 GPUs. This cluster's worker node has T4 GPUs and is labeled `accelerator=nvidia-t4`. The affinity rule was never updated, so `requiredDuringSchedulingIgnoredDuringExecution` forces every pod to stay `Pending` because no node carries the `nvidia-v100` value.

There are two valid paths to fix this:

- **Fix the affinity rule** — update the deployment to require `nvidia-t4` instead of `nvidia-v100`. Use this when the manifest is wrong and the node labels are correct.
- **Fix the node label** — update node01's label to `nvidia-v100`. Use this only if the label itself was applied incorrectly and the hardware actually is a V100. Never relabel nodes to match a bad manifest.
