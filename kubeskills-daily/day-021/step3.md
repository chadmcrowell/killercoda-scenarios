## Step 3: Remove finalizer to allow deletion

```bash
kubectl patch configmap test-cm -p '{"metadata":{"finalizers":[]}}' --type=merge
```{{exec}}

```bash
kubectl get configmap test-cm
```{{exec}}

Finalizer removal completes deletion.
