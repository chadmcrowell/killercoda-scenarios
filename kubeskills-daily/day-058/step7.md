## Step 7: Test path type differences

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-types
spec:
  ingressClassName: nginx
  rules:
  - host: paths.example.com
    http:
      paths:
      - path: /v1
        pathType: Prefix  # Matches /v1, /v1/, /v1/anything
        backend:
          service:
            name: app-v1-svc
            port:
              number: 80
      - path: /v2/exact
        pathType: Exact  # Only matches /v2/exact
        backend:
          service:
            name: app-v2-svc
            port:
              number: 80
EOF

# Test Prefix matching
curl -H "Host: paths.example.com" http://$INGRESS_IP/v1/test

# Test Exact matching
curl -H "Host: paths.example.com" http://$INGRESS_IP/v2/exact
curl -H "Host: paths.example.com" http://$INGRESS_IP/v2/exact/more  # Should 404
```

PathType controls matching behavior and can cause routing surprises.
