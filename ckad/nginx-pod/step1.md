Create a pod named `nginx` in the `session283884` namespace using the image `nginx:1.17`.

Once created, verify the pod is running by describing the pod and checking the status field.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 run nginx --image=nginx:1.17 --restart=Never
```{{exec}}

```bash
kubectl -n session283884 get pod nginx
```{{exec}}

```bash
kubectl -n session283884 describe pod nginx
```{{exec}}

</details>