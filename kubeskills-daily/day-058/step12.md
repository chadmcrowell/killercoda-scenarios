## Step 12: Test rewrite annotations

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rewrite-test
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: rewrite.example.com
    http:
      paths:
      - path: /app
        pathType: Prefix
        backend:
          service:
            name: app-v1-svc
            port:
              number: 80
EOF

# Test - /app/anything rewrites to /anything
curl -H "Host: rewrite.example.com" http://$INGRESS_IP/app/test
```{{exec}}

Controller annotations change routing behavior.
