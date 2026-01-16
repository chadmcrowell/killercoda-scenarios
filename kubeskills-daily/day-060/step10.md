## Step 10: Test controller without leader election

```bash
# Deploy multiple replicas without leader election
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: no-leader-controller
  namespace: default
spec:
  replicas: 3  # Multiple replicas!
  selector:
    matchLabels:
      app: no-leader
  template:
    metadata:
      labels:
        app: no-leader
    spec:
      serviceAccountName: broken-controller
      containers:
      - name: controller
        image: bash:5
        command: ["/bin/bash"]
        args:
        - -c
        - |
          TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
          API=https://kubernetes.default.svc

          POD_NAME=$(hostname)
          echo "Controller $POD_NAME starting (NO LEADER ELECTION)"

          while true; do
            echo "[$POD_NAME] Reconciling..."

            # All replicas reconcile simultaneously!
            # Causes duplicate work and conflicts

            TASKS=$(curl -s -k -H "Authorization: Bearer $TOKEN" \
              $API/apis/example.com/v1/namespaces/default/apptasks | \
              grep -o '"name":"[^"]*"' | cut -d'"' -f4)

            for TASK in $TASKS; do
              echo "[$POD_NAME] Processing $TASK"
            done

            sleep 3
          done
EOF

# Check duplicate reconciliation
kubectl logs -l app=no-leader --tail=30 | grep "Reconciling"

# All 3 replicas reconcile the same resources!
```{{exec}}

Leader election prevents multiple replicas from doing duplicate work.
