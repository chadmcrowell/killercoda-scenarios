## Step 6: Test Exact pathType

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: exact-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /api/users
        pathType: Exact
        backend:
          service:
            name: api-v1-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80
EOF
```{{exec}}

```bash
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ -z "$INGRESS_IP" ]; then
  INGRESS_IP="localhost:8080"
  pgrep -f "port-forward.*ingress-nginx-controller 8080:80" >/dev/null || kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80 >/tmp/ingress-port-forward.log 2>&1 &
  sleep 3
fi

echo "=== Testing /api/users (exact match) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api/users

echo "=== Testing /api/users/ (trailing slash, no match!) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api/users/

echo "=== Testing /api/users/123 (falls to prefix) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api/users/123
```{{exec}}

Exact matching is brittle—a trailing slash changes the route.
