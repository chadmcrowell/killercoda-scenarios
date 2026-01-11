## Step 9: Test TLS with missing secret

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-broken
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - tls.example.com
    secretName: nonexistent-tls-secret  # Doesn't exist!
  rules:
  - host: tls.example.com
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

# Check status
kubectl describe ingress tls-broken | grep -A 10 "Events:"
```

Ingress TLS requires a Secret in the same namespace.
