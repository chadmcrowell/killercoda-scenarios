## Step 10: DaemonSet default behavior

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-monitor
spec:
  selector:
    matchLabels:
      app: monitor
  template:
    metadata:
      labels:
        app: monitor
    spec:
      containers:
      - name: monitor
        image: nginx
EOF
```{{exec}}

```bash
kubectl get pod $(kubectl get pods -l app=monitor -o jsonpath='{.items[0].metadata.name}') -o yaml | grep -A 20 tolerations
```{{exec}}

DaemonSets include default tolerations that let them survive NotReady indefinitely.
