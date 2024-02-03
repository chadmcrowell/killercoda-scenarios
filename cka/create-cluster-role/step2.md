Bind the cluster role 'acme-corp-clusterrole' to the service account ’secure-sa’ making sure the 'secure-sa' service account can only create the assigned resources within the default namespace and nowhere else.

Verify that the service account can only create deployments, replicaSets, and daemonSets in the default namespace.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a role binding named 'acme-corp-role-binding', add 'acme-corp-clusterrole' role and 'Sandra' user
kubectl -n default create rolebinding acme-corp-role-binding --clusterrole=acme-corp-clusterrole --serviceaccount=default:secure-sa

# list the newly created cluster role and role binding
kubectl get clusterrole,rolebinding

# using 'auth can-i', verify that you can create deployments as the 'secure-sa' service account in the default namespace
kubectl auth can-i create deploy --namespace default --as=system:serviceaccount:default:secure-sa

# using 'auth can-i', verify that you CANNOT delete daemonSets as the 'secure-sa' service account in the kube-system namespace 
kubectl auth can-i delete ds --namespace kube-system --as=system:serviceaccount:default:secure-sa

```{{exec}}


</details>