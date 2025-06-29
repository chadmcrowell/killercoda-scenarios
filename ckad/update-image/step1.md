Update the deployment named `web` in the `session283884` namespace to use the image `nginx:1.19`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 set image deployment/web nginx=nginx:1.19
```{{exec}}

```bash
kubectl -n session283884 rollout status deployment/web
```{{exec}}

</details>