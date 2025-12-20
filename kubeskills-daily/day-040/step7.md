## Step 7: Simulate webhook with TLS

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: webhook-service
spec:
  selector:
    app: webhook
  ports:
  - port: 443
    targetPort: 8443
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webhook
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webhook
  template:
    metadata:
      labels:
        app: webhook
    spec:
      containers:
      - name: webhook
        image: hashicorp/http-echo
        args: ["-text=webhook response", "-listen=:8443"]
        ports:
        - containerPort: 8443
        volumeMounts:
        - name: tls
          mountPath: /tls
          readOnly: true
      volumes:
      - name: tls
        secret:
          secretName: short-lived-tls
EOF
```{{exec}}

Webhook echoes over HTTPS using the short-lived cert secret.
