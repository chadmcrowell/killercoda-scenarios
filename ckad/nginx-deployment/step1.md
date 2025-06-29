Create a deployment named `web` in the `session283884` namespace with 3 replicas using the image `nginx:1.18`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create deployment web --image=nginx:1.18
```{{exec}}

```bash
kubectl -n session283884 scale deployment web --replicas=3
```{{exec}}

```bash
kubectl -n session283884 get deploy,rs,po
```{{exec}}

</details>