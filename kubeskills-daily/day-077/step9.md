## Step 9: Secret in image

```bash
# Dockerfile with hardcoded secret (bad!)
cat > /tmp/bad-dockerfile << 'EOF'
FROM nginx
ENV API_KEY=supersecretkey123
COPY config.yaml /etc/config.yaml
# config.yaml contains passwords!
EOF

echo "Secrets in images:"
echo "- Baked into image layers"
echo "- Visible with 'docker history'"
echo "- Pushed to registry"
echo "- Can't rotate without rebuilding"
echo "- Anyone who pulls image gets secrets"
```{{exec}}

Secrets baked into container images are permanently exposed in image layers and registries.
