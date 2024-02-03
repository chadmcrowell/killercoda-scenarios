Create a new role binding named `sa-creator-binding` that will bind to the `sa-creator` role and apply to a user named `Sandra` in the default namespace.

Verify that you can create service accounts with the Sandra user using `auth can-i`

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a role binding named 'sa-creator-binding', add 'sa-creator' role and 'Sandra' user
kubectl create rolebinding sa-creator-binding --role=sa-creator --user=Sandra

# list the newly created role and role binding
kubectl get role,rolebinding

# using 'auth can-i', verify that you can create service accounts as Sandra
kubectl auth can-i create sa --namespace default --as Sandra

```{{exec}}


</details>