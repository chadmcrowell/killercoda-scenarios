Change the IP address associated with the cluster's DNS Service. 

It's the `kube-dns` service in the `kube-system` namespace. `k -n kube-system edit svc kube-dns`

<br>
<details><summary>Solution</summary>
<br>

```bash
# edit the kube-dns service in the kube-system namespace
kubectl -n kube-system edit svc kube-dns
```{{exec}}

```yaml
...
# in the service YAML, modify the 'strategy'. save and quit to apply the changes!
spec:
  clusterIP: 100.96.0.10
  clusterIPs:
  - 100.96.0.10
  internalTrafficPolicy: Cluster
...
```{{copy}}

> NOTE: The change will not be applied, but the YAML will be saved in the `/tmp` directory

```bash
# to force the change, replace the service with the YAML that was saved in the /tmp directory
# NOTE: The name of the YAML file will be different for you
kubectl replace -f /tmp/kubectl-edit-3485293250.yaml --force 

```{{exec}}

```bash
# see the new IP address given to the service
k -n kube-system get svc

```{{exec}}

The output should look similar to the following:
```bash
controlplane $ k -n kube-system get svc
NAME       TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   100.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   6s
```


</details>