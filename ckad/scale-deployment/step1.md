Scale an existing deployment named `web` in the `session283884` namespace to 5 replicas.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 scale deployment web --replicas=5
```{{exec}}

```bash
kubectl -n session283884 get deploy,rs,po
```{{exec}}

</details>