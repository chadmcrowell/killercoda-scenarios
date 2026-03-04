# Congratulations

You've completed Day 89: **Node Affinity — Scheduling Where You Want**.

## What You Learned

- **`requiredDuringSchedulingIgnoredDuringExecution`** is a hard constraint — the pod stays Pending indefinitely if no node matches; use it when correct node placement is non-negotiable
- **`preferredDuringSchedulingIgnoredDuringExecution`** is a soft hint — the scheduler tries to honor it but schedules the pod anywhere if no match exists; unmet preferences produce no warning or event
- `IgnoredDuringExecution` on both types means running pods are **never evicted** if a matching label is removed from their node after they've started
- `kubectl describe pod` → Events section is the first stop when a pod is stuck Pending due to affinity; the message says exactly how many nodes didn't match
- `kubectl get nodes --show-labels` and `kubectl get nodes -l <key>=<value>` are essential tools for cross-referencing affinity rules against actual node state
- Required and preferred affinity rules can be **combined in the same spec** — use required for correctness constraints and preferred (with `weight`) to express performance or topology preferences
- `weight` on preferred rules (1–100) lets you stack multiple preferences with different priorities; the scheduler scores nodes and picks the highest total

Keep building. See you tomorrow!

— Chad

KubeSkills Daily — Fail Fast, Learn Faster
