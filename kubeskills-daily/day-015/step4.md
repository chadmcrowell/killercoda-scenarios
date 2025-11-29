## Step 4: Test path routing (unexpected behavior!)

```bash
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ -z "$INGRESS_IP" ]; then
  INGRESS_IP="localhost:8080"
  pgrep -f "port-forward.*ingress-nginx-controller 8080:80" >/dev/null || kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80 >/tmp/ingress-port-forward.log 2>&1 &
  sleep 3
fi

echo "=== Testing /api ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api

echo "=== Testing /api/v2 ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api/v2

echo "=== Testing /api/v2/users ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/api/v2/users
```{{exec}}

`/api` matches first and captures `/api/v2*`—traffic still reaches api-v1-svc.
