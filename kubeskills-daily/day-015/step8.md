## Step 8: Path rewriting

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rewrite-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /external/api/v1
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

echo "=== Testing /external/api/v1 (rewrites to /) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/external/api/v1
```{{exec}}

Backend receives `/` instead of the incoming path because of the rewrite annotation.
