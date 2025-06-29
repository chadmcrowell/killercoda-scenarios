Use `kubectl debug` to attach an ephemeral container to a running pod named `nginx`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 run nginx --image=nginx
```{{exec}}

```bash
kubectl -n session283884 debug -it nginx --image=busybox --target=nginx
```{{exec}}

</details>