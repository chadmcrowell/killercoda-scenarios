Create a pod named `redis-pod` that uses the image `redis:7` and exposes port `6379`. Use the command `redis-server /redis-master/redis.conf` to store redis configuration data and store this in an `emptyDir` volume. 

Mount the `redis-config` configmap as a volume to the pod for use within the container.

**HINT:** create the pod YAML with a `--dry-run` using the following command:
```bash
k run redis-pod --image=redis:7 --port 6379 --command 'redis-server' '/redis-master/redis.conf' --dry-run=client -o yaml > redis-pod.yaml
```{{exec}}

<br>
<details><summary>Solution</summary>
<br>

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: redis-pod
  name: redis-pod
spec:
  containers:
  - command:
    - redis-server
    - /redis-master/redis.conf
    image: redis:7
    name: redis-pod
    volumeMounts:
      - name: config-volume
        mountPath: /redis-master
    ports:
    - containerPort: 6379
  volumes:
    - name: config-volume
      configMap:
        name: redis-config
```


</details>