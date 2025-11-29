## Step 2: Try to delete it

```bash
kubectl delete configmap test-cm
```{{exec}}

```bash
kubectl get configmap test-cm
kubectl get configmap test-cm -o yaml | grep -A 5 metadata
```{{exec}}

Resource shows deletionTimestamp but persists because finalizer remains.
