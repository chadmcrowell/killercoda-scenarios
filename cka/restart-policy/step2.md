Determine why the pod is not running
```bash
k get po
```{{exec}}

Change the `restartPolicy` to prevent the pod from automatically restarting.

> NOTE: you can read more about `restartPolicy` here: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-restarts

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a pod named 'busybox-sleeper' using the image from the local registry
kubectl edit po busybox
```{{exec}}

```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: busybox
  name: busybox
spec:
  containers:
  - image: busybox
    name: busybox
  restartPolicy: Never # change this from Always to Never
```


</details>