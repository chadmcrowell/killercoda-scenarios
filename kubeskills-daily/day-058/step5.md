## Step 5: Test wrong service name

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wrong-service
spec:
  ingressClassName: nginx
  rules:
  - host: wrong.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nonexistent-service  # Doesn't exist!
            port:
              number: 80
EOF

# Check Ingress events
kubectl describe ingress wrong-service | grep -A 10 "Events:"
```{{exec}}

Backends must reference an existing Service.
