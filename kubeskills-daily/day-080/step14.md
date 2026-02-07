## Step 14: Configure rate limit bypass

```bash
# ServiceAccount with priority class
cat <<EOF > /tmp/priority-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: high-priority-sa
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: high-priority-role
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: high-priority-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: high-priority-role
subjects:
- kind: ServiceAccount
  name: high-priority-sa
  namespace: default
---
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: FlowSchema
metadata:
  name: high-priority-flow
spec:
  distinguisherMethod:
    type: ByUser
  matchingPrecedence: 1
  priorityLevelConfiguration:
    name: workload-high
  rules:
  - subjects:
    - kind: ServiceAccount
      serviceAccount:
        name: high-priority-sa
        namespace: default
    resourceRules:
    - verbs: ["*"]
      apiGroups: ["*"]
      resources: ["*"]
EOF

cat /tmp/priority-serviceaccount.yaml

echo ""
echo "Priority configuration:"
echo "- Critical services get higher priority"
echo "- Lower priority requests queued"
echo "- Prevents starvation"
```{{exec}}

FlowSchemas and PriorityLevelConfigurations let you assign critical services higher API priority to avoid throttling.
