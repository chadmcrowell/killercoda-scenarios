Deploy a pod that crashes after 10 seconds and view its logs.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 run crashme --image=busybox --restart=Never -- /bin/sh -c 'sleep 10; exit 1'
```{{exec}}

```bash
kubectl -n session283884 logs crashme --previous
```{{exec}}

</details>