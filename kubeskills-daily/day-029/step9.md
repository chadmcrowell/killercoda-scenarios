## Step 9: Create valid database

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: valid-db
spec:
  engine: "postgres"
  storageSize: "50Gi"
  replicas: 3
  backup:
    enabled: true
    schedule: "0 2 * * *"
CR
```{{exec}}

Should be accepted with valid values.

```bash
kubectl get database valid-db -o yaml
```{{exec}}
