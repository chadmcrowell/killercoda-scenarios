## Step 13: Test ClusterIssuer (cluster-wide)

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cluster-selfsigned
spec:
  selfSigned: {}
EOF
```{{exec}}

```bash
kubectl create namespace other-ns

cat <<'EOF' | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cross-ns-cert
  namespace: other-ns
spec:
  secretName: cross-ns-tls
  issuerRef:
    name: cluster-selfsigned
    kind: ClusterIssuer
  dnsNames:
  - other.example.com
EOF
```{{exec}}

ClusterIssuer can issue certificates across namespaces.
