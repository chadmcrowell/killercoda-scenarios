## Step 16: Test helm lint

```bash
helm lint .
helm lint . -f override.yaml
```{{exec}}

Lint validates template syntax and common chart issues.
