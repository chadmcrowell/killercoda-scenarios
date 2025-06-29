Create a Role to read pods and a RoleBinding to attach it to ServiceAccount `build-bot`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create role pod-reader --verb=get,list,watch --resource=pods
```{{exec}}

```bash
kubectl -n session283884 create rolebinding read-pods-binding --role=pod-reader --serviceaccount=session283884:build-bot
```{{exec}}

</details>