## Step 8: Test TLS secret in wrong namespace

```bash
kubectl create namespace other-ns
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cross-namespace-tls
  namespace: other-ns
spec:
  tls:
  - hosts:
    - example.com
    secretName: example-tls
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

kubectl describe ingress cross-namespace-tls -n other-ns | grep -i "error\|warning"

echo ""
echo "TLS secret not found - must be in same namespace as Ingress"
```{{exec}}

Ingress controllers only look for TLS Secrets within the same namespace as the Ingress resource. Referencing a Secret from another namespace silently fails — the controller falls back to its default certificate or drops TLS entirely.
