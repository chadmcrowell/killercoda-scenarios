## Step 10: Test digest pinning

```bash
# Bad: Using tag (mutable)
cat <<EOF > /tmp/tag-deployment.yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: app
        image: nginx:1.21  # Tag can change!
EOF

# Good: Using digest (immutable)
cat <<EOF > /tmp/digest-deployment.yaml
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      containers:
      - name: app
        image: nginx@sha256:10d1f5b58f74683ad34eb29287e07dab1e90f10af243f151bb50aa5dbb4d62ee
        # Digest is immutable - exact image version
EOF

echo "Tag vs Digest:"
cat /tmp/tag-deployment.yaml
echo "---"
cat /tmp/digest-deployment.yaml

echo ""
echo "Digest pinning benefits:"
echo "- Immutable reference"
echo "- Exact image version"
echo "- Prevents tag mutation attacks"
echo "- Reproducible deployments"
```{{exec}}

Digest pinning provides immutable image references that cannot be silently replaced, unlike mutable tags.
