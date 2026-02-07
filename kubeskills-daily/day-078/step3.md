## Step 3: Test hostPath volume mount

```bash
# Mount host filesystem
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-pod
spec:
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
    volumeMounts:
    - name: host-root
      mountPath: /host
  volumes:
  - name: host-root
    hostPath:
      path: /
      type: Directory
EOF

kubectl wait --for=condition=Ready pod hostpath-pod --timeout=60s

# Access host filesystem
kubectl exec hostpath-pod -- ls -la /host/etc | head -10
kubectl exec hostpath-pod -- cat /host/etc/hostname

echo "With hostPath:"
echo "- Full read/write to host filesystem"
echo "- Can modify systemd configs"
echo "- Can read host secrets"
echo "- Can create backdoors"
```{{exec}}

hostPath volumes expose the entire host filesystem to the container - one of the most common escape vectors.
