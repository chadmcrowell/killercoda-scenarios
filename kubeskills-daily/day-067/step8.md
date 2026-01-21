## Step 8: Test init container with volume

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-volume
spec:
  initContainers:
  - name: setup-data
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Setting up data..."
      echo "Config data" > /data/config.txt
      echo "Setup complete!"
    volumeMounts:
    - name: shared-data
      mountPath: /data
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'cat /data/config.txt; sleep 3600']
    volumeMounts:
    - name: shared-data
      mountPath: /data
  volumes:
  - name: shared-data
    emptyDir: {}
EOF

kubectl wait --for=condition=Ready pod init-volume --timeout=60s

# Check main container can see init data
kubectl logs init-volume -c app
```{{exec}}

Confirm init containers can pre-populate shared volumes.
