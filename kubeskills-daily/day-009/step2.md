## Step 2: Deploy pod with ConfigMap as env vars AND volume

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-test
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'while true; do echo "--- ENV VARS ---"; echo "APP_MODE=$APP_MODE"; echo "LOG_LEVEL=$LOG_LEVEL"; echo "--- VOLUME FILE ---"; cat /config/config.json; echo ""; sleep 10; done']
    env:
    - name: APP_MODE
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_MODE
    - name: LOG_LEVEL
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: LOG_LEVEL
    volumeMounts:
    - name: config-volume
      mountPath: /config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
EOF
```{{exec}}

```bash
kubectl logs config-test -f
```{{exec}}

Keep the log stream running; it prints env vars and the mounted JSON file.
