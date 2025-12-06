## Step 5: Simulate CNI configuration issue (hostNetwork bypass)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: host-network-pod
spec:
  hostNetwork: true
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pod host-network-pod -o wide
```{{exec}}

The IP matches the node IP because hostNetwork skips the CNI plugin.
