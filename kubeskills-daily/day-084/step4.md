## Step 4: Test wrong IngressClass

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: wrong-class-ingress
spec:
  ingressClassName: nonexistent-class
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

sleep 10

kubectl get ingress wrong-class-ingress

echo ""
echo "Ingress ignored by controllers (IngressClass doesn't exist)"
```{{exec}}

Specifying a non-existent `ingressClassName` causes every controller to ignore the Ingress — all controllers only process resources that reference their own class.
