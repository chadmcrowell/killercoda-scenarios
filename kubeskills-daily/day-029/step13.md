## Step 13: Update status (separate from spec)

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: status-test
spec:
  engine: "postgres"
  storageSize: "10Gi"
CR
```{{exec}}

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: status-test
spec:
  engine: "postgres"
  storageSize: "10Gi"
status:
  phase: "Ready"
CR
```{{exec}}

Status is ignored when sent via spec; update it using the status subresource:

```bash
kubectl patch database status-test --subresource=status --type=merge -p '{"status":{"phase":"Ready"}}'
```{{exec}}
