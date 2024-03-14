Change the image used for the pods in the 'apache' deployment to `httpd:alpine`{{copy}}.

<br>
<details><summary>Solution</summary>
<br>

```bash
# change the image used for the deployment
kubectl set image deploy apache httpd=httpd:latest httpd=httpd:alpine

# list the image used in the deployment to verify the change was successful
kubectl get deploy apache -o yaml | grep image

```{{exec}}


</details>