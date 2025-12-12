## Step 11: Test owner reference garbage collection

```bash
kubectl delete webapp test-app
sleep 2
kubectl get configmap test-app-config 2>&1 || echo "ConfigMap deleted (garbage collected)"
```{{exec}}

Owner references should delete the ConfigMap with its WebApp owner.
