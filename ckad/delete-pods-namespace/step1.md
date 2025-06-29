Delete all pods in the namespace `session283884` but leave the namespace intact.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 delete pods --all
```{{exec}}

</details>