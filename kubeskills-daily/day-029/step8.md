## Step 8: Test integer range validation

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: too-many-replicas
spec:
  engine: "postgres"
  storageSize: "10Gi"
  replicas: 20
CR
```{{exec}}

Should fail because replicas has a max of 10.
