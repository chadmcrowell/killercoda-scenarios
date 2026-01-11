## Step 8: Test conflicting Ingress rules

```bash
# Create two Ingresses with same host
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conflict-a
spec:
  ingressClassName: nginx
  rules:
  - host: conflict.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-v1-svc
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conflict-b
spec:
  ingressClassName: nginx
  rules:
  - host: conflict.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-v2-svc
            port:
              number: 80
EOF

# Check which one wins
kubectl describe ingress conflict-a conflict-b | grep -A 5 "Rules:"
```

Last applied wins, which can be non-deterministic.
