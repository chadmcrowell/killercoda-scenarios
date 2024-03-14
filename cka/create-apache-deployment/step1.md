Create a deployment named “apache” that uses the image `httpd:latest`{{copy}}

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a deployment named "apache" that uses the image 'httpd:latest' and contains three pods
kubectl create deploy apache --image httpd:latest

# list the deployment and the pods in that deployment
kubectl get deploy,po
```{{exec}}


</details>