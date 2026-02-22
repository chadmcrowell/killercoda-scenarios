## Step 5: Test missing backend service

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: missing-backend-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: nonexistent-service
            port:
              number: 80
EOF

sleep 10

kubectl describe ingress missing-backend-ingress | grep -i "error\|warning"

echo ""
echo "Backend service doesn't exist - traffic will 404 or 503"
```{{exec}}

An Ingress referencing a non-existent Service will be accepted but any request matching that path returns 503 (or 404 depending on the controller). The Ingress itself shows no events unless a controller is watching.
