## Step 11: Test template debugging

```bash
# Render templates without installing
helm template test-release broken-app

# Debug specific template
helm template test-release broken-app --show-only templates/deployment.yaml

# Dry-run installation
helm install test-release broken-app --dry-run --debug
```{{exec}}

Rendering locally helps catch template issues before install.
