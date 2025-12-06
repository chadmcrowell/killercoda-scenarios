## Step 11: Debug with manual image pull

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: image-debug
spec:
  containers:
  - name: tools
    image: docker:latest
    command: ['sleep', '3600']
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
EOF
```{{exec}}

```bash
kubectl exec image-debug -- docker pull private-registry.example.com/myapp:v1.0
```{{exec}}

This surfaces the exact registry error from the runtime (unauthorized, timeout, or DNS failure).
