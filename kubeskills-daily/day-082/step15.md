## Step 15: Drift reconciliation

```bash
cat > /tmp/reconcile-drift.sh << 'EOF'
#!/bin/bash
echo "=== Configuration Drift Reconciliation ==="

echo -e "\n1. Current Drift Summary:"
/tmp/drift-impact.sh

echo -e "\n2. Reconciliation Options:"
echo ""
echo "Option A: Revert to Git (discard manual changes)"
echo "  kubectl apply -f /tmp/baseline-deployment.yaml"
echo "  kubectl apply -f /tmp/baseline-configmap.yaml"
echo ""
echo "Option B: Update Git with current state"
echo "  kubectl get deployment myapp -o yaml > git-repo/deployment.yaml"
echo "  git commit -am 'Sync with production state'"
echo ""
echo "Option C: Selective merge"
echo "  Review each change individually"
echo "  Keep critical changes, revert others"

echo -e "\n3. Prevention:"
echo "  - Enable GitOps auto-sync"
echo "  - Restrict kubectl access"
echo "  - Implement admission control"
echo "  - Monitor for drift continuously"

echo -e "\n4. Next Steps:"
echo "  1. Document all current changes"
echo "  2. Get stakeholder approval for reconciliation"
echo "  3. Execute reconciliation plan"
echo "  4. Enable drift prevention"
echo "  5. Train team on GitOps workflow"
EOF

chmod +x /tmp/reconcile-drift.sh
/tmp/reconcile-drift.sh
```{{exec}}

Reconcile drift by choosing to revert to Git, update Git with current state, or selectively merge changes.
