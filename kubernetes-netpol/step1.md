Create a deployment named 'nginx' that uses the `nginx` image. Create a service from that deployment, also named `nginx` exposed on port `80`

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a deployment named 'nginx' that uses the nginx image
kubectl create deployment nginx --image=nginx

# expose the deployment on port 80 via service named 'nginx'
kubectl expose deployment nginx --port=80
```{{exec}}

```bash
# list the deployment, service and pod
k get deploy,svc,po
```{{exec}}


</details>