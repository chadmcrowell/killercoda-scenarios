## Step 7: See which pod was evicted first

```bash
kubectl get pods -o wide
kubectl describe pod <evicted-pod-name> 2>/dev/null || echo "Pod already gone"
```{{exec}}

BestEffort pods are evicted before Burstable and Guaranteed.
