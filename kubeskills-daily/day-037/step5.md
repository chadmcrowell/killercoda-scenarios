## Step 5: Test readOnly volume mount

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: readonly-cm
data:
  config.txt: "readonly content"
---
apiVersion: v1
kind: Pod
metadata:
  name: readonly-mount
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c']
    args:
    - |
      echo "Reading file..."
      cat /config/config.txt
      echo "Attempting write..."
      echo "new content" > /config/config.txt 2>&1 || echo "Write blocked (readonly)"
      sleep 3600
    volumeMounts:
    - name: config
      mountPath: /config
      readOnly: true
  volumes:
  - name: config
    configMap:
      name: readonly-cm
EOF
```{{exec}}

**Check logs:**
```bash
kubectl logs readonly-mount
```{{exec}}

Writes are blocked by the readOnly mount.
