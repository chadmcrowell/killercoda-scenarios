Create a pod named `nginx-pf` and forward port 8080 on your machine to port 80 of the pod.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 run nginx-pf --image=nginx --port=80
```{{exec}}

```bash
kubectl -n session283884 port-forward pod/nginx-pf 8080:80
```{{exec}}

</details>