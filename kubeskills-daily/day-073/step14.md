## Step 14: Test node affinity for tenant isolation

```bash
# Label nodes for specific tenants
NODE=$(kubectl get nodes -o name | head -1 | cut -d'/' -f2)
kubectl label node $NODE tenant=team-a

# Deploy pod with node affinity
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: isolated-pod
  namespace: team-a
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: tenant
            operator: In
            values:
            - team-a
  containers:
  - name: app
    image: nginx
EOF

kubectl get pod isolated-pod -n team-a -o wide
```{{exec}}

Node affinity can dedicate nodes to specific tenants.
