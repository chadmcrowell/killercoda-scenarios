## Step 14: Check node image cache

```bash
# List images on node (if accessible)
echo "Images cached on nodes:"
kubectl get nodes -o wide

# In production, you would check:
# crictl images (for containerd)
# docker images (for docker)

echo "Image caching:"
echo "- First pull: downloads from registry"
echo "- Subsequent pulls: uses local cache (unless imagePullPolicy: Always)"
echo "- Cache saved in /var/lib/containerd or /var/lib/docker"
```{{exec}}

Review how node caches affect image pull behavior.
