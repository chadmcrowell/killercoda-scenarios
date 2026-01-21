## Step 6: Check for failed pod networking

```bash
# Look for pods stuck in ContainerCreating
kubectl get pods -A --field-selector status.phase=Pending

# Check pod events for network errors
for pod in $(kubectl get pods -l app=exhaust -o name | head -5); do
  echo "Checking $pod:"
  kubectl describe $pod | grep -A 5 "Events:" | grep -i "network\|cni"
done
```{{exec}}

Inspect pending pods and events for network errors.
