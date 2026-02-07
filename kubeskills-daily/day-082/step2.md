## Step 2: Simulate manual hotfix (drift begins)

```bash
# Emergency production change (not in Git!)
kubectl patch deployment myapp -p '{"spec":{"template":{"spec":{"containers":[{"name":"app","env":[{"name":"HOTFIX_ENABLED","value":"true"}]}]}}}}'

echo "Manual hotfix applied (not documented)"
echo ""
echo "Current state:"
kubectl get deployment myapp -o yaml | grep -A 5 "env:"

echo ""
echo "Git state (baseline):"
grep -A 5 "env:" /tmp/baseline-deployment.yaml

echo ""
echo "Drift detected: HOTFIX_ENABLED not in Git!"
```{{exec}}

A manual hotfix adds an environment variable directly to the cluster - the first step toward configuration drift.
