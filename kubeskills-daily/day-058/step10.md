## Step 10: Create valid TLS secret

```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=tls.example.com/O=tls.example.com"

# Create secret
kubectl create secret tls tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key

# Create Ingress with TLS
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-working
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - tls.example.com
    secretName: tls-secret
  rules:
  - host: tls.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-v1-svc
            port:
              number: 80
EOF

# Test HTTPS
curl -k -H "Host: tls.example.com" https://$INGRESS_IP/
```{{exec}}

A valid TLS secret fixes HTTPS routing.
