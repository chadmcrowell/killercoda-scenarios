## Step 5: Test image tag drift

```bash
# Update image without updating manifest
kubectl set image deployment/myapp app=nginx:1.22

echo "Image updated to nginx:1.22"
echo ""
echo "Current: $(kubectl get deployment myapp -o jsonpath='{.spec.template.spec.containers[0].image}')"
echo "Git: nginx:1.21"
echo ""
echo "Drift: Different image version running"
```{{exec}}

Using `kubectl set image` updates the running container but leaves Git pointing to the old version.
