## Step 6: Test subPath mount (broken updates)

```bash
kubectl delete pod config-test
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: subpath-test
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'while true; do echo "--- SUBPATH FILE ---"; cat /app/config.json; sleep 10; done']
    volumeMounts:
    - name: config-volume
      mountPath: /app/config.json
      subPath: config.json  # This breaks auto-updates!
  volumes:
  - name: config-volume
    configMap:
      name: app-config
EOF
```{{exec}}

```bash
kubectl logs subpath-test -f
```{{exec}}

subPath mounts copy the file once; they do not track updates.
