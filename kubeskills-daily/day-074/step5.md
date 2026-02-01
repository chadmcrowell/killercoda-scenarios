## Step 5: Attempt restore from backup

```bash
# Recreate namespace
kubectl create namespace backup-test

# Restore resources
kubectl apply -f /tmp/backup-resources.yaml

# Check pods
kubectl get pods -n backup-test

# Check data (LOST!)
kubectl wait --for=condition=Ready pod -n backup-test postgres-0 --timeout=120s 2>/dev/null
kubectl exec -n backup-test postgres-0 -- psql -U postgres -c "SELECT * FROM users;" 2>&1 || echo "Data LOST - PV was recreated empty!"
```{{exec}}

Resources restored but application data is LOST!
