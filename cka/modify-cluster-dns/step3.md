With the serviceCIDR rotated and the core services recreated, update every kubelet so new pods use the DNS ClusterIP (`100.96.0.10`) coming from the fresh CIDR. Perform the change to the `config.yaml` on the node where pods run. 

Then, edit the kubelet configMap in the `kube-system` namespace to use DNS 100.96.0.10. Reload the kubelet configuration without restarting the node.


<br>
<details><summary>Solution</summary>
<br>

```bash
# modify the kubelet config on the node
vim /var/lib/kubelet/config.yaml 
```{{exec}}

```yaml
# within the config.yaml file, change the clusterDNS value to 100.96.0.10
...
cgroupDriver: systemd
clusterDNS:
- 100.96.0.10
clusterDomain: cluster.local
...
```{{copy}}

```bash
# edit kubelet configMap with 
k -n kube-system edit cm kubelet-config
```{{exec}}

```bash
# in the kubelet configMap, change the value for clusterDNS to 100.96.0.10
...
data:
  kubelet: |
    apiVersion: kubelet.config.k8s.io/v1beta1
    authentication:
      anonymous:
        enabled: false
      webhook:
        cacheTTL: 0s
        enabled: true
      x509:
        clientCAFile: /etc/kubernetes/pki/ca.crt
    authorization:
      mode: Webhook
      webhook:
        cacheAuthorizedTTL: 0s
        cacheUnauthorizedTTL: 0s
    cgroupDriver: systemd
    clusterDNS:
    - 100.96.0.10
    clusterDomain: cluster.local
...
```{{copy}}

```bash
# apply the update to the kubelet configuration immediately on the node
kubeadm upgrade node phase kubelet-config
systemctl daemon-reload
systemctl restart kubelet
```{{exec}}

> NOTE: Reloading and restarting the kubelet after the `kubeadm upgrade node phase kubelet-config` command guarantees the kubelet consumes the DNS IP that now lives inside the new serviceCIDR.


</details>
