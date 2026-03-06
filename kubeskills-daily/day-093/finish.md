# Congratulations

You've completed Day 93: **Namespace Resource Quota Exhaustion Debugging**.

## What You Learned

- When a Deployment is stuck below its desired replica count with no Pending pods and no pod-level errors, the cause is almost always a quota rejection at API server admission — the pod object is never created
- The failure appears in the **ReplicaSet events**, not the Deployment events — always run `kubectl describe replicaset` when a Deployment won't scale
- `kubectl describe resourcequota` shows `Used` vs `Hard` for every tracked dimension — a dimension at 100% is a hard gate that blocks all new pod creation regardless of node capacity
- **LimitRange injection** silently assigns `defaultRequest` and `default` resource values to any container admitted without an explicit resources block — a deployment spec showing `{}` does not mean the pod consumes zero quota
- The gap between a Deployment's resource spec (`{}`) and the running pod's resource spec (populated values) is the diagnostic fingerprint of LimitRange injection
- Multiple quota dimensions can hit their hard limits simultaneously — a single pod creation attempt can be rejected for `pods`, `requests.memory`, and `limits.memory` all at once
- Fixing quota exhaustion has two layers: the immediate fix (patch the quota to unblock the scale-out) and the structural fix (give every deployment explicit resource requests that reflect actual consumption)

## Why It Matters

Namespace ResourceQuotas are how platform teams protect shared clusters from a single team consuming all capacity. But quotas sized without accounting for LimitRange injection are routinely too small — the team that said their service "uses almost nothing" was not wrong about their process, but they never saw the defaults being injected at admission time. In production, this failure pattern is especially dangerous because it surfaces during scale-out events: the application scales fine in development (where quotas may be absent), then silently stalls in staging or production precisely when traffic demands it most. The four-command runbook — describe ReplicaSet, describe ResourceQuota, describe LimitRange, compare Deployment spec to pod spec — resolves this class of failure in under two minutes.

Keep building. See you tomorrow!

— Chad

KubeSkills Daily — Fail Fast, Learn Faster
