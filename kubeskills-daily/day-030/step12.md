## Step 12: Test finalizer blocking deletion

```bash
cat <<'APP' | kubectl apply -f -
apiVersion: apps.example.com/v1
kind: WebApp
metadata:
  name: with-finalizer
  finalizers:
  - apps.example.com/cleanup
spec:
  message: "Testing finalizers"
APP
```{{exec}}

```bash
kubectl delete webapp with-finalizer
kubectl get webapp with-finalizer
```{{exec}}

Remove the finalizer to unblock deletion:

```bash
kubectl patch webapp with-finalizer --type=json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
```{{exec}}
