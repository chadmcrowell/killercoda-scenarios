Create a new cluster role named “acme-corp-clusterrole” that can create deployments, replicasets and daemonsets. 

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a cluster role named 'acme-corp-clusterrole' and add the verb 'create' for deployments(deploy), replicaSets(rs), and daemonSets(ds)
kubectl create clusterrole acme-corp-clusterrole --verb=create --resource=deploy,rs,ds

# view the newly created role
kubectl get clusterrole
```{{exec}}


</details>