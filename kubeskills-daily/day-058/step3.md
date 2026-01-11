## Step 3: Create Ingress without IngressClass

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: broken-ingress
spec:
  rules:
  - host: app.example.com
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
kubectl get ingress broken-ingress
kubectl describe ingress broken-ingress
```{{exec}}

No address assigned because ingressClassName is missing.
