Create a new role binding named `sa-creator-binding` that will bind to the `sa-creator` role and apply to a user named `Sandra` in the default namespace.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a role binding named 'sa-creator-binding', add 'sa-creator' role and 'Sandra' user
kubectl create rolebinding sa-creator-binding --role=admin --user=Sandra

# list the newly created role and role binding
kubectl get role,rolebinding

```{{exec}}


</details>