## Step 14: Test release management

```bash
# List all releases
helm list -A

# Get release manifest
helm get manifest test-release

# Get release values
helm get values test-release

# Get release hooks
helm get hooks test-release

# Check release history
helm history test-release
```{{exec}}

Helm stores release history and manifests for inspection.
