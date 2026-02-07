## Step 14: Test large manifest timeout

```bash
# Simulate very large manifest
cat > /tmp/gitops-repo/large-manifest.yaml << 'EOF'
# In production: CRD with thousands of lines
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: large.example.com
spec:
  group: example.com
  names:
    kind: Large
    plural: larges
  scope: Namespaced
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            # Imagine 5000 more lines of schema...
EOF

echo "Large manifests cause:"
echo "- Kubectl apply timeout"
echo "- API server timeout"
echo "- Sync marked as failed"
echo "- Need to increase timeout values"
```{{exec}}

Understand how large manifests (especially CRDs) can exceed apply timeouts and cause sync failures.
