Run a pod named `sleeper` in the `session283884` namespace using the `busybox` image and command `sleep 3600`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 run sleeper --image=busybox --restart=Never -- sleep 3600
```{{exec}}

```bash
kubectl -n session283884 get pod sleeper
```{{exec}}

</details>