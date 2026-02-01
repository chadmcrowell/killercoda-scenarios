## Step 3: Test deprecated Ingress API (pre-1.19)

```bash
# Old ingress API (extensions/v1beta1) deprecated in 1.14, removed in 1.22
cat <<EOF > /tmp/old-ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: old-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: my-service
          servicePort: 80
EOF

# Try to apply (may fail on newer clusters)
kubectl apply -f /tmp/old-ingress.yaml 2>&1 || echo "Old Ingress API not supported"

# New API (networking.k8s.io/v1)
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: new-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
EOF
```{{exec}}

Old Ingress API removed in 1.22, must use networking.k8s.io/v1.
