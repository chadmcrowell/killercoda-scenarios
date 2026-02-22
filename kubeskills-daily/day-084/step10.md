## Step 10: Test path rewrite issues

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rewrite-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /\$2
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /app(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

echo "Path rewrite issues:"
echo "- Request: /app/users"
echo "- Rewrite to: /users (if working)"
echo "- Common problems:"
echo "  - Wrong regex in path"
echo "  - Wrong capture group in rewrite-target"
echo "  - PathType must be ImplementationSpecific"
```{{exec}}

Path rewrites require `pathType: ImplementationSpecific` and correct regex capture groups in both the `path` and `rewrite-target` annotation. A mismatch means requests hit the backend with the original path instead of the rewritten one.
