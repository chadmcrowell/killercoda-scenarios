## Step 15: Test Deployment with security violations

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-test
  namespace: restricted-ns
spec:
  replicas: 3
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: app
        image: nginx
EOF
```{{exec}}

**Error:** Deployment created but pods fail to start (violates restricted).

```bash
kubectl get deployment deployment-test -n restricted-ns
kubectl get events -n restricted-ns --sort-by='.lastTimestamp' | grep -i "forbidden"
```{{exec}}
