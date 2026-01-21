## Step 13: Test multiple init containers in sequence

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-sequence
spec:
  initContainers:
  - name: step-1
    image: busybox
    command: ['sh', '-c', 'echo Step 1; sleep 2; echo step1 > /data/step1.txt']
    volumeMounts:
    - name: shared
      mountPath: /data
  - name: step-2
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Step 2"
      if [ ! -f /data/step1.txt ]; then
        echo "Step 1 didn't complete!"
        exit 1
      fi
      sleep 2
      echo step2 > /data/step2.txt
    volumeMounts:
    - name: shared
      mountPath: /data
  - name: step-3
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Step 3"
      if [ ! -f /data/step2.txt ]; then
        echo "Step 2 didn't complete!"
        exit 1
      fi
      echo "All steps complete!"
    volumeMounts:
    - name: shared
      mountPath: /data
  containers:
  - name: app
    image: nginx
  volumes:
  - name: shared
    emptyDir: {}
EOF

# Watch sequential execution
kubectl get pod init-sequence -w
```{{exec}}

Confirm init containers run in strict sequence.
