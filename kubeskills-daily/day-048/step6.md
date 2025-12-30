## Step 6: Identify deprecated APIs in manifests

```bash
cat > /tmp/check-deprecated.sh << 'EOF'
#!/bin/bash
echo "Checking for potentially deprecated APIs..."

deprecated_apis=(
  "extensions/v1beta1"
  "apps/v1beta1"
  "apps/v1beta2"
  "networking.k8s.io/v1beta1"
  "policy/v1beta1"
  "rbac.authorization.k8s.io/v1beta1"
)

for api in "${deprecated_apis[@]}"; do
  echo "Checking for $api..."
  kubectl get --raw /apis 2>/dev/null | grep -q "$api" && echo "  Found: $api" || echo "  Not present"
done
EOF

chmod +x /tmp/check-deprecated.sh
/tmp/check-deprecated.sh
```{{exec}}

Helper script to spot deprecated API groups.
