## Step 5: Test required field validation

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: missing-fields
spec:
  replicas: 3
CR
```{{exec}}

Expect an error about missing spec.engine and spec.storageSize.
