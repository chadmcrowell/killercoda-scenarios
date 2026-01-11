## Step 11: Test cross-namespace secret access

```bash
kubectl create namespace other-ns

# Try to use secret from different namespace
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cross-ns-tls
  namespace: other-ns
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - cross.example.com
    secretName: tls-secret  # In default namespace!
  rules:
  - host: cross.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-v1-svc
            port:
              number: 80
EOF

# Check - TLS won't work
kubectl describe ingress cross-ns-tls -n other-ns | grep -A 10 "Events:"
```

TLS secrets must be in the same namespace as the Ingress.
