## Step 13: Simulate IP exhaustion

```bash
kubectl cluster-info dump | grep -m 1 cluster-cidr

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ip-hungry
spec:
  replicas: 10
  selector:
    matchLabels:
      app: ip-hungry
  template:
    metadata:
      labels:
        app: ip-hungry
    spec:
      containers:
      - name: pause
        image: k8s.gcr.io/pause:3.9
EOF
```{{exec}}

```bash
kubectl get pods -o wide | grep ip-hungry
```{{exec}}

High replica counts can expose CIDR exhaustion and failed IP allocation.
