## Step 10: Test service name collision

```bash
# Services are namespace-scoped, but DNS can be confusing
kubectl create service clusterip shared-name -n team-a --tcp=80:80
kubectl create service clusterip shared-name -n team-b --tcp=80:80

# Full DNS distinguishes them
echo "team-a: shared-name.team-a.svc.cluster.local"
echo "team-b: shared-name.team-b.svc.cluster.local"
echo "Short name 'shared-name' depends on pod's namespace"
```{{exec}}

Service names can collide across namespaces but DNS FQDN resolves correctly.
