## Step 7: Create the dependency

```bash
# Create the missing service
kubectl create service clusterip mysql --tcp=3306:3306

# Now init container completes
sleep 10
kubectl get pod init-dependency
```{{exec}}

Unblock the init container by creating the dependency.
