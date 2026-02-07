## Step 4: Test ConfigMap drift

```bash
# Update ConfigMap directly
kubectl patch configmap myapp-config -p '{"data":{"app.conf":"debug: true\ntimeout: 60s\n"}}'

echo "ConfigMap updated directly in cluster"
echo ""
echo "Current ConfigMap:"
kubectl get configmap myapp-config -o yaml | grep -A 3 "app.conf:"

echo ""
echo "Git ConfigMap:"
grep -A 3 "app.conf:" /tmp/baseline-configmap.yaml

echo ""
echo "Drift: Debug mode enabled, timeout doubled"
```{{exec}}

ConfigMap changes applied directly bypass version control - debug mode is now enabled without any audit trail.
