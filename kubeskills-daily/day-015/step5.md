## Step 5: Fix with rule ordering (longest prefix first)

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
      - path: /api/v2
        pathType: Prefix
        backend:
          service:
            name: api-v2-svc
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-v1-svc
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

echo "=== Testing /api/v2 (should hit v2 now) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api/v2

echo "=== Testing /api (should hit v1) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api
```{{exec}}

Ordering fixes routing—longest prefix should appear first.
