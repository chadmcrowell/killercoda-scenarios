## Step 3: Create invalid custom resource (no validation yet)

```bash
cat <<'CR' | kubectl apply -f -
apiVersion: example.com/v1
kind: Database
metadata:
  name: test-db
spec:
  engine: "anything-goes"
  size: "not-a-number"
  replicas: "should-be-int"
CR
```{{exec}}

Should succeed because there is no schema validation.

```bash
kubectl get database test-db -o yaml
```{{exec}}
