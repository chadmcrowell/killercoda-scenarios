## Step 6: Immutable secrets (prevent accidental changes)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: immutable-secret
type: Opaque
immutable: true
stringData:
  api-key: "fixed-key-never-changes"
EOF
```{{exec}}

```bash
kubectl patch secret immutable-secret -p '{"stringData":{"api-key":"new-key"}}'
```{{exec}}

Patch fails because immutable secrets cannot be modified—you must delete and recreate.
