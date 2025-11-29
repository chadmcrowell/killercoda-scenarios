## Step 12: Force removal (emergency only!)

```bash
kubectl patch configmap controlled-resource -n finalizer-test -p '{"metadata":{"finalizers":[]}}' --type=merge
```{{exec}}

```bash
kubectl edit configmap controlled-resource -n finalizer-test
```{{exec}}

Removing finalizers manually forces deletion—use only when cleanup is impossible.
