List all pods in the `session283884` namespace sorted by restart count in descending order.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 get pods --sort-by=.status.containerStatuses[0].restartCount
```{{exec}}

</details>