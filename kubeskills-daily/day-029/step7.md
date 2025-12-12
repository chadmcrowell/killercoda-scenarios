## Step 7: Test pattern validation

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: invalid-size
spec:
  engine: "postgres"
  storageSize: "10GB"
CR
```{{exec}}

Should fail because storageSize must end with Gi.
