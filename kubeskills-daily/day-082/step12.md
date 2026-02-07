## Step 12: Test service drift

```bash
# Update service type
kubectl patch service myapp -p '{"spec":{"type":"NodePort"}}'

echo "Service type changed to NodePort"
echo ""
echo "Current: $(kubectl get service myapp -o jsonpath='{.spec.type}')"
echo "Git: ClusterIP"
echo ""
echo "Drift: Service type modified"
```{{exec}}

Changing the service type from ClusterIP to NodePort exposes the application externally - a security-relevant drift.
