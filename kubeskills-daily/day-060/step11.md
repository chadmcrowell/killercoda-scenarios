## Step 11: Test watch on wrong resources

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wrong-watch-controller
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wrong-watch
  template:
    metadata:
      labels:
        app: wrong-watch
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

          echo "Starting controller with wrong watch..."

          # BUG: Watches ALL pods instead of just AppTask resources
          # Triggers reconciliation on every pod event!

          while true; do
            echo "Watching ALL pods (wrong!)"

            curl -s -k -H "Authorization: Bearer $TOKEN" \
              "$API/api/v1/pods?watch=true&timeoutSeconds=10" | \
            while read -r line; do
              echo "Pod event detected, reconciling ALL apptasks!"

              # Unnecessarily reconciles on unrelated pod events
              TASKS=$(curl -s -k -H "Authorization: Bearer $TOKEN" \
                $API/apis/example.com/v1/namespaces/default/apptasks | \
                grep -o '"name":"[^"]*"' | cut -d'"' -f4)

              echo "Reconciled due to irrelevant pod event"
            done
          done
EOF
```{{exec}}

Watching unrelated resources can amplify reconciliation load.
