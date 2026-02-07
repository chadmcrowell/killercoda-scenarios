## Step 11: Test resource drift

```bash
# Update resources directly
kubectl patch deployment myapp -p '{"spec":{"template":{"spec":{"containers":[{"name":"app","resources":{"limits":{"cpu":"2000m","memory":"2Gi"}}}]}}}}'

echo "Resource limits increased"
echo ""
echo "Current limits:"
kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[0].resources.limits}' | jq .

echo ""
echo "Git limits:"
grep -A 4 "resources:" /tmp/baseline-deployment.yaml | head -5

echo ""
echo "Drift: Resources don't match baseline"
```{{exec}}

Resource limit changes bypass capacity planning - undocumented increases can cause scheduling problems cluster-wide.
