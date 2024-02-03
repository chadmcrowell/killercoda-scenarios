Create a service account named `dev`

Create a role binding that will bind the `view` cluster role to the newly created `dev` service account in the default namespace.

Verify that the `dev` service account can view pods and services in the default namespace with `auth can-i`

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a service account named dev
kubectl create sa dev

# create a role binding named 'dev-view-binding' to allow the 'dev' service account to view resources in the default namespace
kubectl create rolebinding dev-view-binding --clusterrole=view --serviceaccount=default:dev --namespace=default

# verify the 'dev' service account can view pods in the default namespace
kubectl auth can-i get po --namespace default --as=system:serviceaccount:default:dev

# verify the 'dev' service account can view services in the default namespace
kubectl auth can-i get svc --namespace default --as=system:serviceaccount:default:dev

# verify that the 'dev' service account CANNOT view the pods in the 'kube-system' namespace
kubectl auth can-i get po --namespace kube-system --as=system:serviceaccount:default:dev
```{{exec}}


</details>