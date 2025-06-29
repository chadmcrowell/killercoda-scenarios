Create a Job named `oneshot` in the `session283884` namespace that runs `echo Hello CKAD`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create job oneshot --image=busybox -- /bin/sh -c 'echo Hello CKAD'
```{{exec}}

```bash
kubectl -n session283884 get jobs
```{{exec}}

</details>