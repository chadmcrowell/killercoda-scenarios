## Step 17: Dry-run installation

```bash
cd ..
helm install myapp-release ./myapp --dry-run --debug | head -50
```{{exec}}

Shows what Helm would install without touching the cluster.
