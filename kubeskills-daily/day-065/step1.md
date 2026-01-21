## Step 1: Test nonexistent image

```bash
# Try to pull image that doesn't exist
kubectl run nonexistent --image=nginx:nonexistent-tag-12345

# Check status
sleep 10
kubectl get pod nonexistent
kubectl describe pod nonexistent | grep -A 10 "Events:"
```{{exec}}

See ErrImagePull followed by ImagePullBackOff.
