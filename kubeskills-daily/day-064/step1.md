## Step 1: Check available StorageClasses

```bash
# List storage classes
kubectl get storageclass

# Check default storage class
kubectl get storageclass -o jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io/is-default-class=="true")].metadata.name}'
echo ""
```{{exec}}

Identify available StorageClasses and the default class.
