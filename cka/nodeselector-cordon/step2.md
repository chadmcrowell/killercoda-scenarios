Create a pod named 'nginx' that uses the image `nginx`.

See which node the pod is scheduled to.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a pod named 'nginx' that uses the image 'nginx'
kubectl run nginx --image nginx

# see which node the pod was scheduled to
kubectl get po -o wide


```{{exec}}


</details>