# Congratulations

You've completed Day 87: **DaemonSet Failures — When Node-Level Pods Won't Deploy**.

## What You Learned

- **DESIRED=0** on a DaemonSet doesn't mean success — it means the controller found no eligible nodes, almost always caused by a `nodeSelector` or `nodeAffinity` that matches nothing
- **DESIRED > READY with Pending pods** means pods are being created but can't be scheduled — the first stop is `kubectl describe pod` to read the `FailedScheduling` event
- Every `NoSchedule` taint on every node in the cluster must have a matching toleration in the DaemonSet pod spec — including `node-role.kubernetes.io/control-plane`
- DaemonSets designed to run cluster-wide need tolerations for **all** node taints, not just custom ones
- Fixing a `nodeSelector` mismatch requires labeling nodes — the DaemonSet controller reconciles automatically once eligible nodes exist
- `kubectl get nodes --show-labels` and `kubectl describe node <name>` are the first tools to reach for when a DaemonSet has unexpected DESIRED counts or Pending pods
- DESIRED=0 is a silent failure — no events, no errors — making `nodeSelector` misconfigurations easy to miss without checking the spec directly

Keep building. See you tomorrow!

— Chad

KubeSkills Daily — Fail Fast, Learn Faster
