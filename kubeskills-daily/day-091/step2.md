# Step 2 — Identify the Root Cause

Each Deployment is failing for a different reason. Work through them one at a time.

## Diagnose gpu-inference: Label Does Not Exist

Describe any `gpu-inference` Pending pod:

```bash
kubectl describe pod -l app=gpu-inference | grep -A10 "Events:"
```{{exec}}

Event output:

```text
Warning  FailedScheduling  ...
  0/2 nodes are available:
  2 node(s) didn't match Pod's node affinity/selector.
```

Extract the exact nodeSelector the Deployment is requesting:

```bash
kubectl get deployment gpu-inference \
  -o jsonpath='{.spec.template.spec.nodeSelector}{"\n"}'
```{{exec}}

Output: `{"hardware":"gpu"}`

Now check whether any node carries the `hardware` label at all:

```bash
kubectl get nodes -L hardware
```{{exec}}

The `HARDWARE` column is empty for every node. The label key doesn't exist anywhere in the cluster.

```bash
kubectl get nodes -l hardware=gpu
```{{exec}}

Output: `No resources found`

### Root Cause 1 — gpu-inference: label `hardware=gpu` does not exist on any node

---

## Diagnose fast-cache: Wrong Label Value

```bash
kubectl describe pod -l app=fast-cache | grep -A10 "Events:"
```{{exec}}

Same scheduling failure message. Extract the nodeSelector:

```bash
kubectl get deployment fast-cache \
  -o jsonpath='{.spec.template.spec.nodeSelector}{"\n"}'
```{{exec}}

Output: `{"disktype":"nvme"}`

The pod requires `disktype=nvme`. Check what `disktype` label the nodes actually have:

```bash
kubectl get nodes -L disktype
```{{exec}}

`node01` has `disktype=ssd`. The key is correct but the value is wrong — `nvme` vs `ssd`. Node selectors are **exact string matches**. A single character difference is a complete mismatch.

Confirm no node has the required value:

```bash
kubectl get nodes -l disktype=nvme
```{{exec}}

Output: `No resources found`

### Root Cause 2 — fast-cache: `disktype` label exists but has value `ssd`; pod requires `nvme`

---

## Diagnose data-processor: Two Blockers

This one is trickier. Start with the scheduling event:

```bash
kubectl describe pod -l app=data-processor | grep -A15 "Events:"
```{{exec}}

Read the message carefully. It will say something like:

```text
0/2 nodes are available:
  1 node(s) had untolerated taint {maintenance: true},
  2 node(s) didn't match Pod's node affinity/selector.
```

Two separate problems are listed. Extract the nodeSelector:

```bash
kubectl get deployment data-processor \
  -o jsonpath='{.spec.template.spec.nodeSelector}{"\n"}'
```{{exec}}

Output: `{"workload":"batch"}`

Check whether any node has `workload=batch`:

```bash
kubectl get nodes -l workload=batch
```{{exec}}

Output: `No resources found` — the label is missing entirely.

Now check the toleration spec in the pod:

```bash
kubectl get deployment data-processor \
  -o jsonpath='{.spec.template.spec.tolerations}{"\n"}'
```{{exec}}

Output: `null` — no tolerations. Recall the taint you applied in Step 1:

```bash
kubectl describe node node01 | grep -A3 Taints
```{{exec}}

`node01` has `maintenance=true:NoSchedule`. Even if you add the `workload=batch` label to `node01`, the pod still won't schedule because it has no toleration for the maintenance taint.

**Both blockers must be fixed:**

1. Add `workload=batch` label to `node01`
2. Remove the `maintenance` taint from `node01` (or add a toleration to the pod)

### Root Cause 3 — data-processor: missing `workload=batch` label AND `maintenance:NoSchedule` taint with no matching toleration

---

## Summary of Findings

| Deployment      | nodeSelector         | Problem                                        | Fix Required                              |
|-----------------|----------------------|------------------------------------------------|-------------------------------------------|
| `gpu-inference` | `hardware=gpu`       | Label key doesn't exist on any node            | Add label to target node                  |
| `fast-cache`    | `disktype=nvme`      | Key exists but value is `ssd` not `nvme`       | Correct the label value on the node       |
| `data-processor`| `workload=batch`     | Label missing + `maintenance` taint blocking   | Add label and remove taint                |
