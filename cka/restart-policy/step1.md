Use `kubectl` to create a pod named `busybox` that uses the `busybox` image.

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a pod named 'busybox-sleeper' using the image from the local registry
kubectl run busybox --image busybox
```{{exec}}


</details>

