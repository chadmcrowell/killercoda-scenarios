## Step 4: Fix with IngressClass

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: working-ingress
spec:
  ingressClassName: nginx  # Required!
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
kubectl get ingress working-ingress
```{{exec}}

IngressClass lets the controller claim the Ingress.
