Uncordon `node01`

Delete the pod, and edit the pod YAML, adding the nodeName selector to ensure that it's scheduled to `node01`

See which node the pod was scheduled to.

<br>
<details><summary>Solution</summary>
<br>

```bash
# mark the node01 schedulable (uncordon)
kubectl uncordon node01

# delete the existing pod
kubectl delete po nginx

# edit the pod yaml
kubectl run nginx --image nginx --dry-run=client -o yaml > pod.yaml
```{{exec}}

```yaml
# add the nodeName to pod.yaml to schedule the pod to node01
...
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  nodeName:
    node01
  containers:
  - image: nginx
    name: nginx
...
```
```bash
# see which node the pod is scheduled to 
k get po -o wide
```

</details>