## Step 3: Test kubectl edit (undocumented change)

```bash
# Simulate interactive edit (creates drift)
kubectl get deployment myapp -o yaml | \
  sed 's/replicas: 3/replicas: 5/' | \
  kubectl apply -f -

echo "Replica count changed via kubectl edit"
echo ""
echo "Current: $(kubectl get deployment myapp -o jsonpath='{.spec.replicas}') replicas"
echo "Git: 3 replicas"
echo ""
echo "Drift: Replica count differs from source of truth"
```{{exec}}

Changing replica count directly in the cluster creates drift - the running state no longer matches Git.
