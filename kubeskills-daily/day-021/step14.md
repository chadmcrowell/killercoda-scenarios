## Step 14: Common built-in finalizers

```bash
kubectl get namespace default -o jsonpath='{.metadata.finalizers}' && echo ""
kubectl get pv -o jsonpath='{.items[*].metadata.finalizers}' && echo ""
kubectl get svc kubernetes -o jsonpath='{.metadata.finalizers}' && echo ""
```{{exec}}

Built-in examples: `kubernetes.io/pvc-protection`, `kubernetes.io/pv-protection`, and the namespace `kubernetes` finalizer.
