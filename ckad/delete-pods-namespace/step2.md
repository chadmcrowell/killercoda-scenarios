After deleting the pods in the `session283884` namespace, observe that new pods immediately appear. Why?

> Kubectl Tip: The `kubectl get pods -w` command streams pod status so you can watch what happens after you delete them.

## Challenge
Delete whatever is causing the pods to regenerate so the namespace stays empty without deleting the namespace itself.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 delete deployment demo-app
```{{exec}}

```bash
kubectl -n session283884 get pods
```{{exec}}

</details>
