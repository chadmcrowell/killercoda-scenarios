## Step 15: Create upgrade checklist

```bash
cat > /tmp/upgrade-checklist.sh << 'EOF'
#!/bin/bash
echo "=== Kubernetes Upgrade Checklist ==="

echo -e "\n1. Current Cluster Version:"
kubectl version --short

echo -e "\n2. Deprecated API Usage:"
echo "Checking for beta APIs..."
kubectl api-resources | grep -i beta | head -10

echo -e "\n3. Resources Using Deprecated APIs:"
# Check deployments
kubectl get deployments -A -o json | jq -r '
  .items[] |
  select(.apiVersion != "apps/v1") |
  "\(.metadata.namespace)/\(.metadata.name): \(.apiVersion)"
' | head -5

echo -e "\n4. Check for PodSecurityPolicy:"
kubectl get psp 2>&1 | head -5 || echo "PSP not found (good if 1.25+)"

echo -e "\n5. Webhooks API Version Support:"
kubectl get validatingwebhookconfigurations -o json | jq -r '
  .items[] |
  "\(.metadata.name): \(.webhooks[0].admissionReviewVersions | join(", "))"
' | head -5

kubectl get mutatingwebhookconfigurations -o json | jq -r '
  .items[] |
  "\(.metadata.name): \(.webhooks[0].admissionReviewVersions | join(", "))"
' | head -5

echo -e "\n6. CRD Versions:"
kubectl get crd -o custom-columns=NAME:.metadata.name,VERSIONS:.spec.versions[*].name | head -10

echo -e "\n7. Upgrade Path:"
CURRENT=$(kubectl version -o json | jq -r '.serverVersion.minor' | sed 's/[^0-9]//g')
NEXT=$((CURRENT + 1))
echo "Current: 1.$CURRENT"
echo "Next: 1.$NEXT"
echo "Rule: Upgrade one minor version at a time"

echo -e "\n8. Pre-Upgrade Actions:"
echo "   - Review changelog for 1.$NEXT"
echo "   - Check deprecated APIs"
echo "   - Update CRDs if needed"
echo "   - Update admission webhooks"
echo "   - Test in staging first"
echo "   - Backup etcd"
echo "   - Update kubectl"

echo -e "\n9. Post-Upgrade Verification:"
echo "   - Check all pods Running"
echo "   - Verify API server responding"
echo "   - Test application functionality"
echo "   - Check for deprecation warnings"
echo "   - Review logs for errors"
EOF

chmod +x /tmp/upgrade-checklist.sh
/tmp/upgrade-checklist.sh
```{{exec}}

Complete upgrade checklist for safe version migration.
