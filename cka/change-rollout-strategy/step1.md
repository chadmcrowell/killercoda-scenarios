Create a deployment named `source-ip-app` that uses the image `registry.k8s.io/echoserver:1.4`.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a deployment named "source-ip-app" that uses the image 'registry.k8s.io/echoserver:1.4'
kubectl create deploy source-ip-app --image registry.k8s.io/echoserver:1.4

# list the deployment and the pods in that deployment
kubectl get deploy,po


```{{exec}}


</details>