Create a new pod in Kubernetes using the image from the local registry (the one you just pushed).

> HINT: You can view the images in the local registry with the command `curl localhost:5000/v2/busybox-sleep/tags/list`{{exec}}

If the container is not running, fix the pod YAML so that the container does not restart automatically.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a pod named 'busybox-sleeper' using the image from the local registry
kubectl run busybox-sleeper --image localhost:5000/busybox-sleep
```{{exec}}

```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: busybox-sleeper
  name: busybox-sleeper
spec:
  containers:
  - image: localhost:5000/busybox-sleep
    name: busybox-sleeper
  dnsPolicy: ClusterFirst
  restartPolicy: Always
```


</details>