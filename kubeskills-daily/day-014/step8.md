## Step 8: Quota scopes (priority-based)

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: high-priority-quota
spec:
  hard:
    cpu: "2"
    memory: "2Gi"
  scopeSelector:
    matchExpressions:
    - operator: In
      scopeName: PriorityClass
      values: ["high"]
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: low-priority-quota
spec:
  hard:
    cpu: "500m"
    memory: "512Mi"
  scopeSelector:
    matchExpressions:
    - operator: In
      scopeName: PriorityClass
      values: ["low"]
EOF
```{{exec}}

Separate quotas enforce different limits per priority class.
