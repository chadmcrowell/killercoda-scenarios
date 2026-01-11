## Step 7: Test hostPath violations

```bash
# Try hostPath (BLOCKED by baseline)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: blocked-hostpath
  namespace: baseline-ns
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: host
      mountPath: /host
  volumes:
  - name: host
    hostPath:
      path: /
      type: Directory
EOF
```{{exec}}

Expected error: violates PodSecurity baseline due to hostPath volumes.
