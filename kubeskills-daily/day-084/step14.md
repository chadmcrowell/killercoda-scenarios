## Step 14: Test default backend

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: default-backend-ingress
spec:
  defaultBackend:
    service:
      name: web-service
      port:
        number: 80
  rules:
  - host: specific.example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
EOF

echo "Default backend behavior:"
echo "- Catches all unmatched requests"
echo "- No host specified = uses default"
echo "- No path match = uses default"
echo "- Useful for custom 404 pages"
```{{exec}}

The `defaultBackend` catches all requests that don't match any rule — wrong hostname, unmatched path, or missing Host header. It's useful for custom error pages but can mask misconfigurations if set too broadly.
