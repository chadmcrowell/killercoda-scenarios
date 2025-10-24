Create a pod named `redis-pod` that uses the image `redis:7` and exposes port `6379`. Use the command `redis-server /redis-master/redis.conf` to store redis configuration data and store this in an `emptyDir` volume. 

Mount the `redis-config` configmap data to the pod for use within the container.

> **⚠️ HINT:** create the pod YAML with a `--dry-run`


<details><summary>Solution</summary>
<br>

```bash
k run redis-pod --image=redis:7 --port 6379 --command 'redis-server' '/redis-master/redis.conf' --dry-run=client -o yaml > redis-pod.yaml
```{{exec}}

```bash
cat <<'EOF' > redis-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis-pod
spec:
  containers:
  - name: redis
    image: redis:7
    command:
    - redis-server
    - /redis-master/redis.conf
    ports:
    - containerPort: 6379
    volumeMounts:
    - name: config
      mountPath: /redis-master
    - name: data
      mountPath: /redis-data
  volumes:
  - name: config
    configMap:
      name: redis-config
  - name: data
    emptyDir: {}
EOF
```{{exec}}

```bash
k apply -f redis-pod.yaml
```{{exec}}

```bash
k get pod redis-pod -o wide
```{{exec}}

</details>
