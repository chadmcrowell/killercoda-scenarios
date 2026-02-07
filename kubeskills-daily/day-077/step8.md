## Step 8: Secret in ConfigMap (wrong!)

```bash
# Using ConfigMap for secret data
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: wrong-secret
data:
  api-key: "my-super-secret-key-12345"
  db-password: "admin123"
EOF

# ConfigMaps are NOT for secrets!
kubectl get configmap wrong-secret -o yaml

echo "ConfigMaps:"
echo "- Visible in plain text"
echo "- No access control by default"
echo "- Not designed for sensitive data"
```{{exec}}

ConfigMaps store data in plain text with no encryption - never use them for sensitive credentials.
