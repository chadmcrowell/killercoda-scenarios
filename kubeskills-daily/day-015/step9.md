## Step 9: Multiple Ingress rules (same host)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-1
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /service1
        pathType: Prefix
        backend:
          service:
            name: api-v1-svc
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-2
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /service2
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

echo "=== Testing /service1 (from ingress-1) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/service1

echo "=== Testing /service2 (from ingress-2) ==="
curl -H "Host: api.example.com" http://$INGRESS_IP/service2
```{{exec}}

Ingresses with the same host are merged by nginx—watch for overlapping paths.
