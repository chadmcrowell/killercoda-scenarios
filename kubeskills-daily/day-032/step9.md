## Step 9: Test sync failure with invalid YAML

```bash
cd /tmp/gitops-repo

cat > broken.yaml << 'BROKEN'
apiVersion: v1
kind: ConfigMap
metadata:
  name: broken
  namespace: default
data:
  key: value
  # Invalid: missing colon
  invalid
BROKEN

# Trigger sync
argocd app sync demo-app 2>&1 || echo "Sync failed"
```{{exec}}

Should fail with a JSON/YAML unmarshal error.
