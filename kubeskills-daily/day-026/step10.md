## Step 10: Simulate disk pressure

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: disk-filler
spec:
  containers:
  - name: filler
    image: busybox
    command:
    - sh
    - -c
    - |
      dd if=/dev/zero of=/tmp/bigfile bs=1M count=1000
      sleep 3600
    volumeMounts:
    - name: temp
      mountPath: /tmp
  volumes:
  - name: temp
    emptyDir: {}
EOF
```{{exec}}

```bash
kubectl exec disk-filler -- df -h /tmp
```{{exec}}

Fill disk to trigger DiskPressure.
