## Step 9: Test ConfigMap quota

```bash
# Create ConfigMaps up to limit
for i in 1 2 3 4 5; do
  kubectl create configmap cm-$i -n quota-test --from-literal=key=value
done

# Try to create 6th (exceeds quota of 5)
kubectl create configmap cm-6 -n quota-test --from-literal=key=value 2>&1 || echo "ConfigMap creation blocked"
```{{exec}}

Hit the ConfigMap count quota.
