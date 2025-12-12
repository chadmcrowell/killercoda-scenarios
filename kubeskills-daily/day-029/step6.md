## Step 6: Test enum validation

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: invalid-engine
spec:
  engine: "oracle"
  storageSize: "10Gi"
CR
```{{exec}}

Should fail because engine must be postgres, mysql, or mongodb.
