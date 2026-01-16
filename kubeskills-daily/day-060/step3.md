## Step 3: Deploy broken controller (never updates status)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: broken-controller
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: broken-controller
rules:
- apiGroups: ["example.com"]
  resources: ["apptasks"]
  verbs: ["get", "list", "watch", "update", "patch"]
- apiGroups: ["example.com"]
  resources: ["apptasks/status"]
  verbs: ["get", "update", "patch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "create", "update", "delete"]
- apiGroups: [""]
  resources: ["events"]
  verbs: ["create", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: broken-controller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: broken-controller
subjects:
- kind: ServiceAccount
  name: broken-controller
  namespace: default
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: broken-controller
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: broken-controller
  template:
    metadata:
      labels:
        app: broken-controller
    spec:
      serviceAccountName: broken-controller
      containers:
      - name: controller
        image: bash:5
        command: ["/bin/bash"]
        args:
        - -c
        - |
          # Simulate broken controller that reconciles but never updates status
          TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
          API=https://kubernetes.default.svc

          echo "Starting broken controller..."

          while true; do
            # Get all AppTask resources
            TASKS=$(curl -s -k -H "Authorization: Bearer $TOKEN" \
              $API/apis/example.com/v1/namespaces/default/apptasks | grep -o '"name":"[^"]*"' | cut -d'"' -f4)

            for TASK in $TASKS; do
              echo "Reconciling $TASK (but NOT updating status!)"

              # Simulate reconciliation work
              sleep 0.5

              # BUG: Never updates status.observedGeneration
              # This causes infinite reconciliation!
            done

            sleep 2
          done
EOF

kubectl wait --for=condition=Ready pod -l app=broken-controller --timeout=60s
```{{exec}}

A controller that never updates status will reconcile forever.
