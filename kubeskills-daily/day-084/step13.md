## Step 13: Test rate limiting

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rate-limited-ingress
  annotations:
    nginx.ingress.kubernetes.io/limit-rps: "1"
    nginx.ingress.kubernetes.io/limit-connections: "1"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

echo "Rate limiting annotations:"
echo "- limit-rps: requests per second"
echo "- limit-connections: concurrent connections"
echo "- Exceeding limits = 503 responses"
echo "- Applied per IP address"
```{{exec}}

Rate limiting at the Ingress level protects backend services from overload. Limits are enforced per source IP — legitimate users hitting the limit get 503s, which can look like backend failures during incidents.
