Scale the deployment named 'apache' from 3 replicas to 5.

<br>
<details><summary>Solution</summary>
<br>

```bash
# scale the apache deployment to 5 replicas
kubectl scale deploy apache --replicas 5

# list the now 5 pods in the deployment
kubectl get deploy,po

```{{exec}}


</details>