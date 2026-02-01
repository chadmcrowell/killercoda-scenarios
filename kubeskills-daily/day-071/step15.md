## Step 15: Diagnose operator issues

```bash
cat > /tmp/operator-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== Operator Diagnosis ==="

echo -e "\n1. Custom Resource Definitions:"
kubectl get crd

echo -e "\n2. CRs with Finalizers:"
kubectl get crd -o json | jq -r '.items[].metadata.name' | while read crd; do
  group=$(kubectl get crd $crd -o jsonpath='{.spec.group}')
  version=$(kubectl get crd $crd -o jsonpath='{.spec.versions[?(@.storage==true)].name}')
  plural=$(kubectl get crd $crd -o jsonpath='{.spec.names.plural}')

  kubectl get $plural -A -o json 2>/dev/null | jq -r --arg crd "$crd" '
    .items[] |
    select(.metadata.finalizers != null and (.metadata.finalizers | length) > 0) |
    "\(.metadata.namespace)/\(.metadata.name) [\($crd)]: \(.metadata.finalizers | join(", "))"
  '
done | head -10

echo -e "\n3. Resources Stuck in Terminating:"
kubectl get all -A | grep Terminating

echo -e "\n4. Namespaces Stuck in Terminating:"
kubectl get namespaces | grep Terminating

echo -e "\n5. Operator Pods Status:"
kubectl get pods -A -l 'app in (operator, controller, manager)' -o wide 2>/dev/null | head -10

echo -e "\n6. Recent Operator Events:"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "operator\|controller\|crd" | tail -10

echo -e "\n7. Common Operator Issues:"
echo "   - Missing RBAC: Operator can't manage resources"
echo "   - CRD validation: Invalid CRs rejected"
echo "   - Stuck finalizers: Resources can't be deleted"
echo "   - Operator crash: Resources not reconciled"
echo "   - Watch errors: Operator can't see changes"
echo "   - Conversion webhook down: Multi-version CRDs fail"
EOF

chmod +x /tmp/operator-diagnosis.sh
/tmp/operator-diagnosis.sh
```{{exec}}

Complete diagnostic output for operator and CRD issues.
