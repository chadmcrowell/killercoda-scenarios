## Step 6: Test host namespace violations

```bash
# Try hostNetwork (BLOCKED by baseline)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: blocked-hostnetwork
  namespace: baseline-ns
spec:
  hostNetwork: true
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

Expected error: violates PodSecurity baseline due to hostNetwork.
