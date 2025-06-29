Patch the deployment `web` in the `session283884` namespace to change the container port to `8080`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 patch deployment web --type=json \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/ports/0/containerPort", "value":8080}]'
```{{exec}}

```bash
kubectl -n session283884 get deploy web -o yaml
```{{exec}}

</details>