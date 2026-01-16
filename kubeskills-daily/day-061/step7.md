## Step 7: Rollback failed upgrade

```bash
# Check revision history
helm history test-release

# Rollback to previous revision
helm rollback test-release

# Verify rollback
kubectl get pods -l app=test-release -w
```{{exec}}

Rollback creates a new revision and restores the prior spec.
