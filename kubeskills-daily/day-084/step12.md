## Step 12: Test conflicting Ingress rules

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conflict-ingress-1
spec:
  rules:
  - host: conflict.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: conflict-ingress-2
spec:
  rules:
  - host: conflict.example.com
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

echo "Conflicting Ingress rules:"
echo "- Multiple Ingresses for same host"
echo "- Behavior depends on controller"
echo "- May merge or conflict"
echo "- Better to use one Ingress with multiple paths"
```{{exec}}

Multiple Ingress objects sharing the same hostname have undefined merge behavior — some controllers merge paths, others give precedence to the oldest resource. Always consolidate rules for the same host into a single Ingress.
