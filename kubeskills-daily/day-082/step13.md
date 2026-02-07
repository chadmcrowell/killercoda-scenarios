## Step 13: Measure drift impact

```bash
cat > /tmp/drift-impact.sh << 'EOF'
#!/bin/bash
echo "=== Drift Impact Analysis ==="

echo -e "\n1. Can we reproduce production?"
echo "   No - Multiple undocumented changes"

echo -e "\n2. Can we rollback safely?"
echo "   Unknown - Current state not in version control"

echo -e "\n3. Does staging match production?"
echo "   No - Different versions, configs, resources"

echo -e "\n4. Can we audit changes?"
echo "   No - Changes not tracked in Git"

echo -e "\n5. Configuration drift summary:"
DRIFT_COUNT=0

# Check image
CURRENT_IMAGE=$(kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[0].image}')
if ! grep -q "$CURRENT_IMAGE" /tmp/baseline-deployment.yaml; then
  echo "  - Image mismatch"
  DRIFT_COUNT=$((DRIFT_COUNT + 1))
fi

# Check replicas
CURRENT_REPLICAS=$(kubectl get deployment myapp -o jsonpath='{.spec.replicas}')
BASELINE_REPLICAS=$(grep "replicas:" /tmp/baseline-deployment.yaml | head -1 | awk '{print $2}')
if [ "$CURRENT_REPLICAS" != "$BASELINE_REPLICAS" ]; then
  echo "  - Replica count mismatch"
  DRIFT_COUNT=$((DRIFT_COUNT + 1))
fi

# Check ConfigMap
if ! diff -q /tmp/baseline-configmap.yaml <(kubectl get configmap myapp-config -o yaml) > /dev/null 2>&1; then
  echo "  - ConfigMap modified"
  DRIFT_COUNT=$((DRIFT_COUNT + 1))
fi

echo ""
echo "Total drift issues: $DRIFT_COUNT"

if [ $DRIFT_COUNT -gt 0 ]; then
  echo "Status: CLUSTER DRIFT DETECTED"
else
  echo "Status: No drift detected"
fi
EOF

chmod +x /tmp/drift-impact.sh
/tmp/drift-impact.sh
```{{exec}}

Measure the cumulative impact of all drift - production can no longer be reproduced, rolled back, or audited.
