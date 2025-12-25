## Step 14: Test terminationGracePeriodSeconds interaction

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: graceful-shutdown
spec:
  terminationGracePeriodSeconds: 30
  containers:
  - name: app
    image: nginx
    lifecycle:
      preStop:
        exec:
          command: ['sh', '-c', 'sleep 20']
    livenessProbe:
      httpGet:
        path: /
        port: 80
      periodSeconds: 5
EOF
```{{exec}}

```bash
kubectl delete pod graceful-shutdown
kubectl get pod graceful-shutdown -w
```{{exec}}

PreStop + grace period gives the pod 20 seconds to exit.
