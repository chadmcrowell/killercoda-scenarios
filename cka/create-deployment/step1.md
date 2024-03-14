Create a deployment named “apache” that uses the image `httpd:2.4.54`{{copy}} and contains three pod replicas

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a deployment named "apache" that uses the image 'httpd:2.4.54' and contains three pods
kubectl create deploy apache --image httpd:2.4.54 --replicas 3

# list the deployment and the pods in that deployment
kubectl get deploy,po
```{{exec}}


</details>