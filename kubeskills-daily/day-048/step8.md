## Step 8: Simulate upgrade pre-check

```bash
cat > /tmp/upgrade-precheck.sh << 'EOF'
#!/bin/bash
echo "=== Upgrade Pre-Check ==="

echo -e "\n1. Checking for deprecated APIs in use..."
kubectl get all -A -o json | jq -r '.items[] | "\(.apiVersion) - \(.kind)"' | sort -u

echo -e "\n2. Checking node versions..."
kubectl get nodes -o custom-columns=NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion

echo -e "\n3. Checking for beta resources..."
kubectl api-resources | grep beta

echo -e "\n4. Checking admission webhooks..."
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations -A

echo -e "\n5. Checking PodSecurityPolicy (removed in 1.25)..."
kubectl get psp 2>/dev/null || echo "  PSP not found (good if 1.25+)"

echo -e "\n6. Checking deprecated Ingress API..."
kubectl get ingress -A -o json 2>/dev/null | jq -r '.items[] | "\(.apiVersion) - \(.metadata.namespace)/\(.metadata.name)"'

echo -e "\nPre-check complete!"
EOF

chmod +x /tmp/upgrade-precheck.sh
/tmp/upgrade-precheck.sh
```{{exec}}

Run pre-checks before upgrading.
