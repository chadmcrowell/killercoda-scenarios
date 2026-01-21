## Step 7: Test service quota

```bash
# Create services up to limit
for i in 1 2 3; do
  kubectl create service clusterip svc-$i -n quota-test --tcp=80:80
done

# Try to create 4th service (exceeds quota of 3)
kubectl create service clusterip svc-4 -n quota-test --tcp=80:80 2>&1 || echo "Service creation blocked by quota"
```{{exec}}

Hit the service quota limit.
