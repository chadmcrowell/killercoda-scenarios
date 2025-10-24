Create a Role in the `session283884` namespace that restricts deleting pods and test access with `kubectl auth can-i`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create role no-delete-pods --verb=get,list --resource=pods
```{{exec}}

```bash
kubectl -n session283884 create rolebinding deny-delete-binding --role=no-delete-pods --serviceaccount=session283884:build-bot
```{{exec}}

```bash
kubectl -n session283884 auth can-i delete pods --as=system:serviceaccount:session283884:build-bot
```{{exec}}

</details>