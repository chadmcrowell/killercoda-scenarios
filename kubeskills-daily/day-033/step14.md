## Step 14: Test timeout configuration

```bash
cat <<'VS' | kubectl apply -f -
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: webapp
spec:
  hosts:
  - webapp
  http:
  - route:
    - destination:
        host: webapp
        subset: v1
    timeout: 1s  # Very aggressive!
VS
```

Deploy a slow version to trigger timeouts:

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-v3-slow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
      version: v3
  template:
    metadata:
      labels:
        app: webapp
        version: v3
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args:
        - "-text=Slow version"
        - "-listen=:5678"
        ports:
        - containerPort: 5678
        lifecycle:
          postStart:
            exec:
              command: ['sh', '-c', 'sleep 5']
APP
```{{exec}}

Timeout should cut slow responses.
