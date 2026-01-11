## Step 8: Test aggregated ClusterRoles

```bash
# Create base ClusterRole
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: base-reader
  labels:
    rbac.example.com/aggregate-to-monitoring: "true"
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring-reader
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.example.com/aggregate-to-monitoring: "true"
rules: []  # Rules aggregated from matching ClusterRoles
EOF

# Check aggregated rules
kubectl get clusterrole monitoring-reader -o yaml | grep -A 20 "rules:"
```{{exec}}

Aggregation merges rules across matching ClusterRoles.
