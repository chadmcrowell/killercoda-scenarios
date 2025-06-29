Create a namespace called `devteam283884` and deploy a pod named `nginx` using image `nginx` inside it.

<details><summary>Solution</summary>
<br>

```bash
kubectl create ns devteam283884
```{{exec}}

```bash
kubectl -n devteam283884 run nginx --image=nginx --restart=Never
```{{exec}}

```bash
kubectl get pods -n devteam283884
```{{exec}}

</details>