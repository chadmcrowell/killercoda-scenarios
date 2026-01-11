## Step 14: Debug Ingress routing

```bash
# Check Ingress status
kubectl get ingress -A

# Describe specific Ingress
kubectl describe ingress working-ingress

# Check service endpoints
kubectl get endpoints app-v1-svc

# Test service directly
kubectl run test-pod --rm -it --image=curlimages/curl -- \
  curl http://app-v1-svc.default.svc/
```{{exec}}

Use describe and endpoints to confirm routing and backend health.
