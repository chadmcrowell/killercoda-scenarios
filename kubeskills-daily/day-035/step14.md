## Step 14: Test StatefulSet init container ordering

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: stateful-init
spec:
  serviceName: stateful-init
  replicas: 3
  selector:
    matchLabels:
      app: stateful-init
  template:
    metadata:
      labels:
        app: stateful-init
    spec:
      initContainers:
      - name: check-predecessor
        image: busybox
        command: ['sh', '-c']
        args:
        - |
          ordinal=${HOSTNAME##*-}
          if [ $ordinal -eq 0 ]; then
            echo "I am pod-0, no predecessor to check"
            exit 0
          fi
          predecessor=$((ordinal - 1))
          echo "Checking for stateful-init-$predecessor..."
          until nslookup stateful-init-$predecessor.stateful-init; do
            echo "Predecessor not ready"
            sleep 2
          done
          echo "Predecessor ready!"
      containers:
      - name: app
        image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: stateful-init
spec:
  clusterIP: None
  selector:
    app: stateful-init
  ports:
  - port: 80
EOF
```{{exec}}

```bash
kubectl get pods -l app=stateful-init -w
```{{exec}}

Pod-0 starts first, then pod-1 waits for pod-0, then pod-2 waits for pod-1.
