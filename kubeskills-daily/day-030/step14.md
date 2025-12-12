## Step 14: Simulate controller with retry backoff

```bash
cat > /tmp/smart-reconcile.sh << 'SMART'
#!/bin/bash
WEBAPP=$1
RETRY_COUNT=0
MAX_RETRIES=3

reconcile() {
  echo "Reconciling $WEBAPP (attempt $RETRY_COUNT)"
  if kubectl get configmap ${WEBAPP}-config &>/dev/null; then
    echo "ConfigMap exists, checking if update needed"
    return 0
  else
    echo "Creating ConfigMap"
    MESSAGE=$(kubectl get webapp $WEBAPP -o jsonpath='{.spec.message}')
    kubectl create configmap ${WEBAPP}-config --from-literal=message="$MESSAGE"
  fi
}

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  if reconcile; then
    echo "Reconciliation successful"
    exit 0
  else
    RETRY_COUNT=$((RETRY_COUNT + 1))
    BACKOFF=$((2 ** RETRY_COUNT))
    echo "Reconciliation failed, retrying in ${BACKOFF}s"
    sleep $BACKOFF
  fi
done

echo "Reconciliation failed after $MAX_RETRIES attempts"
exit 1
SMART

chmod +x /tmp/smart-reconcile.sh
/tmp/smart-reconcile.sh with-conditions
```{{exec}}

Backoff limits retries instead of tight loops.
