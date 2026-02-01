## Step 12: Test cross-namespace Service access

```bash
# NetworkPolicy blocks pod-to-pod
# But can still access via Service if policy allows DNS

# Get service ClusterIP
SVC_B=$(kubectl get svc web -n team-b -o jsonpath='{.spec.clusterIP}')

# Try to access via ClusterIP (blocked by NetworkPolicy)
kubectl run cross-svc -n team-a --rm -it --image=busybox --restart=Never -- \
  wget -O- --timeout=2 http://$SVC_B 2>&1 || echo "Service access also blocked"

# But DNS resolution still works
kubectl run dns-check -n team-a --rm -it --image=busybox --restart=Never -- \
  nslookup web.team-b.svc.cluster.local
```{{exec}}

NetworkPolicy blocks traffic but DNS resolution still works.
