Create a pod named `netshoot` that uses the `nicolaka/netshoot` image. 

Exec into the pod and verify that you can reach the service by it's name `apache-svc`

<br>
<details><summary>Solution</summary>
<br>

```bash
# create a temporary pod named netshoot and get a shell to the container all in the same kubectl command
kubectl run netshoot --image=nicolaka/netshoot --rm --it -- sh

# verify that you can reach the service
wget -0- apache-svc
```{{exec}}


</details>