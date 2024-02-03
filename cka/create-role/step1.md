Create a new role named “sa-creator” that will allow creating service accounts in the default namespace.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a role named 'sa-creator' and add the verb 'create' and resource 'sa' (short for serviceaccounts) 
kubectl create role sa-creator --verb=create --resource=sa

```{{exec}}


</details>