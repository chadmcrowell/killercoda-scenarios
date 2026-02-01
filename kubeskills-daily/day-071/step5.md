## Step 5: Deploy broken operator

```bash
# Create namespace for operator
kubectl create namespace webapp-system

# Create ServiceAccount with insufficient RBAC
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: webapp-operator
  namespace: webapp-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: webapp-operator
rules:
- apiGroups: ["example.com"]
  resources: ["webapps"]
  verbs: ["get", "list", "watch"]
  # Missing: create, update, patch, delete
- apiGroups: ["example.com"]
  resources: ["webapps/status"]
  verbs: ["get"]
  # Missing: update, patch
# Missing: RBAC for deployments, services
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: webapp-operator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: webapp-operator
subjects:
- kind: ServiceAccount
  name: webapp-operator
  namespace: webapp-system
EOF

# Deploy operator with insufficient permissions
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-operator
  namespace: webapp-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp-operator
  template:
    metadata:
      labels:
        app: webapp-operator
    spec:
      serviceAccountName: webapp-operator
      containers:
      - name: operator
        image: bash:5
        command:
        - bash
        - -c
        - |
          echo "Starting operator..."
          TOKEN=\$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
          API=https://kubernetes.default.svc

          while true; do
            # Watch for WebApp resources
            WEBAPPS=\$(curl -s -k -H "Authorization: Bearer \$TOKEN" \
              \$API/apis/example.com/v1/webapps)

            echo "Found webapps:"
            echo "\$WEBAPPS" | grep -o '"name":"[^"]*"' || echo "None"

            # Try to create deployment (will fail - no RBAC)
            echo "Attempting to create deployment..."
            curl -s -k -X POST \
              -H "Authorization: Bearer \$TOKEN" \
              -H "Content-Type: application/json" \
              \$API/apis/apps/v1/namespaces/default/deployments \
              -d '{"metadata":{"name":"test"},"spec":{"replicas":1,"selector":{"matchLabels":{"app":"test"}},"template":{"metadata":{"labels":{"app":"test"}},"spec":{"containers":[{"name":"app","image":"nginx"}]}}}}' \
              2>&1 | grep -o "forbidden\|created" || echo "Failed"

            sleep 10
          done
EOF

kubectl wait --for=condition=Ready pod -n webapp-system -l app=webapp-operator --timeout=60s
```{{exec}}

Operator deployed with deliberately insufficient RBAC permissions.
