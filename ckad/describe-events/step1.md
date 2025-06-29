Create a pod with an invalid image and use `kubectl describe` to inspect the error events.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 run badpod --image=doesnotexist/broken
```{{exec}}

```bash
kubectl -n session283884 describe pod badpod
```{{exec}}

</details>