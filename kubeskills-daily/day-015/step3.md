## Step 3: Create Ingress with greedy Prefix paths

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-v1-svc
            port:
              number: 80
      - path: /api/v2
        pathType: Prefix
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80
EOF
```{{exec}}

```bash
kubectl get ingress api-ingress
kubectl describe ingress api-ingress
```{{exec}}

Prefix rules are listed in creation order—watch how nginx evaluates them.
