# Congratulations

You've completed Day 91: **Pod Pending Due to Node Selector Mismatch**.

## What You Learned

- The scheduler leaves pods in `Pending` **indefinitely** when no node satisfies their `nodeSelector` — there is no timeout, no error event on the Deployment, only on the pod
- `kubectl describe pod` → Events section reports `FailedScheduling` with the exact constraint that failed; reading it carefully tells you whether the issue is a missing label, a wrong value, a taint, or a resource shortage
- `kubectl get nodes -L <key>` shows the value of a specific label across all nodes in a column — faster than `--show-labels` when you know what key you're looking for
- Node selectors are **exact string matches** and case-sensitive — `disktype=SSD` and `disktype=ssd` are completely different
- A pod can be blocked by **multiple independent constraints** simultaneously — fixing the label alone may still leave it Pending if a taint also blocks it; read the full FailedScheduling message
- Removing a taint uses the trailing `-` syntax: `kubectl taint node <name> <key>=<value>:<effect>-`
- Before relabeling a node, check whether other Deployments depend on its current labels with `kubectl get deployments -o jsonpath` — a label change can unblock one workload while breaking another
- The right fix is to trace intent: did the **node** fail to get its label, or did the **pod** get the wrong constraint written into it?

Keep building. See you tomorrow!

— Chad

KubeSkills Daily — Fail Fast, Learn Faster
