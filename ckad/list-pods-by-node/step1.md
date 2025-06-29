List all pods in `session283884` namespace grouped by node they are scheduled on.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 get pods -o wide --sort-by=.spec.nodeName
```{{exec}}

</details>