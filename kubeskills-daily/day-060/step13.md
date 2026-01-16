## Step 13: Test proper controller with status update

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: working-controller
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: working-controller
  template:
    metadata:
      labels:
        app: working-controller
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

          echo "Starting WORKING controller..."

          while true; do
            TASKS=$(curl -s -k -H "Authorization: Bearer $TOKEN" \
              $API/apis/example.com/v1/namespaces/default/apptasks)

            echo "$TASKS" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | while read TASK; do
              # Get current generation
              GEN=$(echo "$TASKS" | grep -A 10 "\\"name\\":\\"$TASK\\"" | grep generation | head -1 | grep -o '[0-9]*')

              # Get observed generation
              OBS_GEN=$(echo "$TASKS" | grep -A 20 "\\"name\\":\\"$TASK\\"" | grep observedGeneration | grep -o '[0-9]*')

              if [ "$GEN" != "$OBS_GEN" ]; then
                echo "Reconciling $TASK (generation $GEN)"

                # Do reconciliation work
                sleep 1

                # IMPORTANT: Update status with observedGeneration
                curl -s -k -X PATCH \
                  -H "Authorization: Bearer $TOKEN" \
                  -H "Content-Type: application/merge-patch+json" \
                  $API/apis/example.com/v1/namespaces/default/apptasks/$TASK/status \
                  -d "{\"status\":{\"phase\":\"Ready\",\"observedGeneration\":$GEN}}"

                echo "Updated status for $TASK"
              else
                echo "$TASK already reconciled (gen=$GEN)"
              fi
            done

            sleep 10  # Check every 10 seconds
          done
EOF

# Check working controller
kubectl logs -f -l app=working-controller

# Only reconciles when generation changes!
```{{exec}}

A proper controller updates status to stop unnecessary loops.
