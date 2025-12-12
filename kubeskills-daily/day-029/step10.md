## Step 10: Test default values

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: defaults-test
spec:
  engine: "mysql"
  storageSize: "20Gi"
  # replicas omitted - should default to 1
  # backup.enabled omitted - should default to false
CR
```{{exec}}

```bash
kubectl get database defaults-test -o jsonpath='{.spec.replicas}'
echo ""
kubectl get database defaults-test -o jsonpath='{.spec.backup.enabled}'
echo ""
```{{exec}}

Defaults should show replicas=1 and backup.enabled=false.
