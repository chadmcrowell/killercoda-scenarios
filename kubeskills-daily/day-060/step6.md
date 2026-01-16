## Step 6: Deploy controller with conflicting logic

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: conflicting-controller
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: conflicting-controller
  template:
    metadata:
      labels:
        app: conflicting-controller
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

          echo "Starting conflicting controller..."

          while true; do
            # This controller always wants replicas=5
            # Conflicts with user's desired state!

            TASKS=$(curl -s -k -H "Authorization: Bearer $TOKEN" \
              $API/apis/example.com/v1/namespaces/default/apptasks | \
              grep -o '"name":"[^"]*"' | cut -d'"' -f4)

            for TASK in $TASKS; do
              echo "Forcing $TASK to replicas=5"

              # Force replicas to 5 (conflicts with spec)
              curl -s -k -X PATCH \
                -H "Authorization: Bearer $TOKEN" \
                -H "Content-Type: application/merge-patch+json" \
                $API/apis/example.com/v1/namespaces/default/apptasks/$TASK \
                -d '{"spec":{"replicas":5}}'
            done

            sleep 3
          done
EOF
```{{exec}}

Two controllers fighting over the same field causes flapping state.
