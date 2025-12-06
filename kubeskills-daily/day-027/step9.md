## Step 9: Create custom FlowSchema

```bash
cat <<EOF | kubectl apply -f -
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: FlowSchema
metadata:
  name: custom-priority
spec:
  distinguisherMethod:
    type: ByUser
  matchingPrecedence: 1000
  priorityLevelConfiguration:
    name: workload-low
  rules:
  - resourceRules:
    - apiGroups: [""]
      resources: ["configmaps"]
      verbs: ["list", "get"]
    subjects:
    - kind: ServiceAccount
      serviceAccount:
        name: api-user
        namespace: default
EOF
```{{exec}}

Creates a FlowSchema for the api-user ServiceAccount to use workload-low priority.
