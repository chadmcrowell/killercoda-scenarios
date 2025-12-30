## Step 6: Create custom FlowSchema

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: FlowSchema
metadata:
  name: test-flow
spec:
  distinguisherMethod:
    type: ByUser
  matchingPrecedence: 1000
  priorityLevelConfiguration:
    name: test-priority
  rules:
  - resourceRules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["list", "get"]
    subjects:
    - kind: User
      user:
        name: test-user
EOF
```{{exec}}

Routes test-user pod gets/lists into the custom priority level.
