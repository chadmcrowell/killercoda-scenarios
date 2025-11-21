Start a pod named 'netshoot' which uses the image `nicolaka/netshoot'. Ensure that the pod will stay in a running state.

Get a shell to the pod and cat the `/etc/resolv.conf` to confirm it is using the new DNS ClusterIP (100.96.0.10) that now falls inside the updated serviceCIDR. Use the `nslookup` tool to verify external name resolution (example.com) through the rebuilt DNS service.

<br>
<details><summary>Solution</summary>
<br>

```bash
# start a pod named 'netshoot' using the image 'nicolaka/netshoot' ensuring that the pod stays in a running state.
kubectl run netshoot --image=nicolaka/netshoot --command sleep --command "3600"
```{{exec}}

```bash
# get a shell to the running container named 'netshoot'
k exec -it netshoot -- bash

```{{exec}}

```bash
# cat the /etc/resolv.conf
cat /etc/resolv.conf
```

```bash
# run nslookup on example.com
nslookup example.com
```

</details>
