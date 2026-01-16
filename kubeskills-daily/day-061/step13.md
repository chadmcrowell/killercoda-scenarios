## Step 13: Test chart validation

```bash
# Lint chart
helm lint broken-app

# Create invalid chart
cat > broken-app/Chart.yaml << 'EOF'
apiVersion: v2
name: broken-app
version: invalid-version  # Invalid!
EOF

# Lint fails
helm lint broken-app 2>&1 || echo "Chart validation failed!"
```{{exec}}

helm lint catches schema and metadata errors.
