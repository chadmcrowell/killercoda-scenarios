## Step 10: Test resource contention

```bash
for i in {1..5}; do
  kubectl run cpu-hog-$i --image=polinux/stress \
    --restart=Never \
    --requests='cpu=100m,memory=64Mi' \
    --limits='cpu=200m,memory=128Mi' \
    -- stress --cpu 2 --timeout 300s
done

watch -n 2 "kubectl top nodes; echo '---'; kubectl top pods | grep cpu-hog"
```{{exec}}

Multiple CPU hogs can starve the node; monitor node and pod usage.
