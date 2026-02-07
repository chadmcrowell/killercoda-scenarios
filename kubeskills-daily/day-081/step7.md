## Step 7: Simulate disk fill

```bash
# Disk space exhaustion
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: disk-fill
spec:
  containers:
  - name: fill
    image: ubuntu
    command:
    - sh
    - -c
    - |
      echo "Filling disk..."
      dd if=/dev/zero of=/tmp/large-file bs=1M count=1024
      sleep 300
    volumeMounts:
    - name: temp
      mountPath: /tmp
  volumes:
  - name: temp
    emptyDir:
      sizeLimit: 2Gi
EOF

kubectl wait --for=condition=Ready pod disk-fill --timeout=60s 2>/dev/null

sleep 10

kubectl exec disk-fill -- df -h /tmp

echo "Disk fill test:"
echo "- Did emptyDir size limit work?"
echo "- Was pod evicted?"
echo "- Did it affect node?"
```{{exec}}

Disk fill tests verify that emptyDir size limits work and that disk pressure triggers proper eviction behavior.
