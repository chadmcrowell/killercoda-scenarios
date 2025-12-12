## Step 9: Simulate infinite loop scenario

```bash
cat > /tmp/bad-operator.sh << 'LOOP'
#!/bin/bash
count=0
while [ $count -lt 20 ]; do
  MESSAGE=$(kubectl get webapp test-app -o jsonpath='{.spec.message}')
  kubectl create configmap test-app-config \
    --from-literal=message="$MESSAGE" \
    --dry-run=client -o yaml | kubectl apply -f -

  kubectl patch webapp test-app --type=merge -p "{\"spec\":{\"lastReconciled\":\"$(date +%s)\"}}" 2>/dev/null

  count=$((count + 1))
  echo "Reconciliation $count"
  sleep 1
done
LOOP

chmod +x /tmp/bad-operator.sh
/tmp/bad-operator.sh
```{{exec}}

Spec updates drive resourceVersion changes, showing how loops pile up.
