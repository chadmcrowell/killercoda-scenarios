## Step 9: Test Deployment under restricted

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  namespace: psa-restricted
spec:
  replicas: 2
  selector:
    matchLabels:
      app: secure
  template:
    metadata:
      labels:
        app: secure
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
        seccompProfile:
          type: RuntimeDefault
      containers:
      - name: nginx
        image: nginx:1.25
        securityContext:
          allowPrivilegeEscalation: false
          runAsNonRoot: true
          runAsUser: 1000
          capabilities:
            drop: ["ALL"]
            add: ["NET_BIND_SERVICE"]
EOF
```{{exec}}

```bash
kubectl get deployment secure-app -n psa-restricted
kubectl get pods -n psa-restricted -l app=secure
```{{exec}}

Deployment should pass restricted checks.
