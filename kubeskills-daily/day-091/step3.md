# Step 3 — Apply the Fix

Fix each Deployment's blocking condition in order and verify pods schedule after each one.

## Fix 1 — gpu-inference: Add the Missing Label

The `hardware=gpu` label doesn't exist on any node. Label `node01` to make it eligible:

```bash
kubectl label node node01 hardware=gpu
```{{exec}}

The scheduler reconciles automatically. Watch the pods schedule:

```bash
kubectl get pods -l app=gpu-inference -o wide -w
```{{exec}}

Press `Ctrl+C` once both pods are `Running`. Both should land on `node01` — the only node with `hardware=gpu`.

Confirm the nodeSelector is now satisfied:

```bash
kubectl get nodes -l hardware=gpu
```{{exec}}

---

## Fix 2 — fast-cache: Correct the Label Value

`node01` has `disktype=ssd` but the pod requires `disktype=nvme`. Change the label value:

```bash
kubectl label node node01 disktype=nvme --overwrite
```{{exec}}

Confirm the value changed:

```bash
kubectl get nodes -L disktype
```{{exec}}

`node01` should now show `nvme`. Watch `fast-cache` schedule:

```bash
kubectl get pods -l app=fast-cache -o wide -w
```{{exec}}

Press `Ctrl+C` once it's `Running`.

> **Thinking point:** In production you'd need to decide whether `ssd` was wrong on the Deployment or wrong on the node. If other workloads already rely on `disktype=ssd`, changing the node label could break them. Always check for other `nodeSelector` users before relabeling.

Check whether any other Deployments still reference `disktype=ssd`:

```bash
kubectl get deployments -o jsonpath='{range .items[*]}{.metadata.name}: {.spec.template.spec.nodeSelector}{"\n"}{end}'
```{{exec}}

---

## Fix 3 — data-processor: Add Label and Remove the Maintenance Taint

Two things must be fixed. Start with the missing label:

```bash
kubectl label node node01 workload=batch
```{{exec}}

Verify:

```bash
kubectl get nodes -l workload=batch
```{{exec}}

But the pod still won't schedule — `node01` still has the `maintenance=true:NoSchedule` taint. Check:

```bash
kubectl describe node node01 | grep -A3 Taints
```{{exec}}

Remove the taint:

```bash
kubectl taint node node01 maintenance=true:NoSchedule-
```{{exec}}

The trailing `-` removes the taint. Verify it's gone:

```bash
kubectl describe node node01 | grep -A3 Taints
```{{exec}}

Now watch the `data-processor` pod schedule:

```bash
kubectl get pods -l app=data-processor -o wide -w
```{{exec}}

Press `Ctrl+C` once it's `Running`.

---

## Final Verification

Confirm every Deployment is fully available:

```bash
kubectl get deployments
```{{exec}}

Expected state:

```text
NAME             READY   UP-TO-DATE   AVAILABLE
data-processor   1/1     1            1
fast-cache       1/1     1            1
gpu-inference    2/2     2            2
```

Confirm no FailedScheduling events remain:

```bash
kubectl get events --sort-by=.lastTimestamp --field-selector reason=FailedScheduling
```{{exec}}

The list should be empty (or only show old events). Review the final node label state to see what the migration completed:

```bash
kubectl get node node01 --show-labels | tr ',' '\n' | grep -v "kubernetes.io"
```{{exec}}

---

## Fix the Spec vs Fix the Node — Decision Guide

Both approaches can resolve a nodeSelector mismatch. Choose based on intent:

| Situation | Fix the Node | Fix the Spec |
|-----------|-------------|--------------|
| The label was supposed to exist but wasn't applied yet | Yes — add the label | No |
| The label value has a typo in the pod spec | No | Yes — correct the typo |
| The node hardware genuinely matches the requirement | Yes — label the node | No |
| The nodeSelector is wrong and targets non-existent hardware | No | Yes — remove or update nodeSelector |
| A migration changed label names cluster-wide | Depends — update both consistently | |

When in doubt: trace the **intent**. Did the node fail to get its label, or did the pod get the wrong constraint written into it?
