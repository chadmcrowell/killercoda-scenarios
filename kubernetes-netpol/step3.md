Create a pod with the label `access=true` that will allow traffic to the nginx pods from the `nginx` deployment that we created in the first step.

<br>
<details><summary>Solution</summary>
<br>

Get a shell to a temporary pod that uses the `access=true` label
```bash
kubectl run busybox --rm -ti --labels="access=true" --image=busybox:1.28 -- /bin/sh
```{{copy}}

From the shell to the the container, try to communicate with the nginx pods via the nginx service
```bash
wget --spider --timeout=1 nginx
```{{copy}}



</details>