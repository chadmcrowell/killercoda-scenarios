## Step 7: Multiple audiences

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multi-audience
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: api-token
      mountPath: /var/run/secrets/api
    - name: vault-token
      mountPath: /var/run/secrets/vault
  volumes:
  - name: api-token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          audience: api.kubernetes
          expirationSeconds: 3600
  - name: vault-token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          audience: vault
          expirationSeconds: 1800
EOF
```{{exec}}

Distinct audiences get distinct tokens for different consumers.
