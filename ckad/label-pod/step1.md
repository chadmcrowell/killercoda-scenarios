Add labels `app=frontend` and `tier=web` to an existing pod named `nginx` in the `session283884` namespace.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 label pod nginx app=frontend tier=web
```{{exec}}

```bash
kubectl -n session283884 get pod nginx --show-labels
```{{exec}}

</details>