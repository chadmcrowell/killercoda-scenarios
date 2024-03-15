Create a deployment named “apache” that uses the image `httpd`{{copy}}.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a deployment named "apache" that uses the image 'httpd'
kubectl create deploy apache --image httpd

# list the deployment and the pods in that deployment
kubectl get deploy,po
```{{exec}}


</details>