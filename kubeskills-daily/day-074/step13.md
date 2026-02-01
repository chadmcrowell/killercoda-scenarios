## Step 13: Test disaster recovery drill

```bash
cat > /tmp/dr-drill.sh << 'EOF'
#!/bin/bash
echo "=== Disaster Recovery Drill ==="

# 1. Validate backup exists
if [ ! -f /tmp/backup-resources.yaml ]; then
  echo "FAIL: Backup file not found"
  exit 1
fi

# 2. Validate backup format
kubectl apply --dry-run=client -f /tmp/backup-resources.yaml > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "FAIL: Backup file corrupted or invalid"
  exit 1
fi

# 3. Calculate restore time
START=$(date +%s)

kubectl create namespace dr-test
kubectl apply -f /tmp/backup-resources.yaml

END=$(date +%s)
DURATION=$((END - START))

echo "Restore took $DURATION seconds"

# 4. Verify restoration
PODS=$(kubectl get pods -n dr-test --no-headers 2>/dev/null | wc -l)
echo "Restored $PODS pods"

# 5. Cleanup
kubectl delete namespace dr-test

if [ $DURATION -gt 300 ]; then
  echo "FAIL: RTO > 5 minutes"
  exit 1
fi

echo "PASS: DR drill successful"
EOF

chmod +x /tmp/dr-drill.sh
/tmp/dr-drill.sh
```{{exec}}

Disaster recovery drills validate backup and measure RTO.
