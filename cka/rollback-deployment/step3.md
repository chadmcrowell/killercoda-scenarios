Using `kubectl`, roll back to a previous version of the deployment (the deployment with the image `httpd`).

<br>
<details><summary>Solution</summary>
<br>

```bash
# view the rollout history
kubectl rollout history deploy apache

# roll back to the previous rollout
kubectl rollout undo deploy apache

# view the status of the rollout
kubectl rollout status deploy apache

```{{exec}}


</details>