## Step 7: Test TLS certificate issues

```bash
cat > /tmp/fake-tls.yaml << 'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: example-tls
type: kubernetes.io/tls
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURBRENDQWVpZ0F3SUJBZ0lKQUtHMDZycldOdGg1TUEwR0NTcUdTSWIzRFFFQkN3VUFNQmt4RnpBVgpCZ05WQkFNTURuZDNkeTVsZUdGdGNHeGxMbU52YlRBZUZ3MHlNekExTURNd01EQXdNREJhRncwek16QTAKTXpBd01EQXdNREJhTUJreEZ6QVZCZ05WQkFNTURuZDNkeTVsZUdGdGNHeGxMbU52YlRDQ0FTSXdEUVlKCktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQUt3SzBvL3pFdlhEb1d4eEd2amRvQXYvZis4NQp4eGZQMEVaVzN0dDVGdGc0TjFUSjhZSkVGREVzZ1E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  tls.key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQWpFQU1BQT0KLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLQo=
EOF

kubectl apply -f /tmp/fake-tls.yaml
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
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

echo "TLS configuration:"
echo "- Secret must be type kubernetes.io/tls"
echo "- Must have tls.crt and tls.key"
echo "- Must be in same namespace as Ingress"
echo "- Certificate must match hostname"
```{{exec}}

TLS Ingress requires a `kubernetes.io/tls` Secret with valid `tls.crt` and `tls.key` data. An invalid or mismatched certificate causes TLS handshake failures visible to clients but not always surfaced as Ingress events.
