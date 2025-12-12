## Step 11: Test nested validation

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: invalid-cron
spec:
  engine: "postgres"
  storageSize: "10Gi"
  backup:
    enabled: true
    schedule: "not-a-cron-expression"
CR
```{{exec}}

Should fail because backup.schedule does not match the cron regex pattern.
