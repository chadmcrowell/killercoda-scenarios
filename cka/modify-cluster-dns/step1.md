Change the service cluster IP range (serviceCIDR) that's given to each service to 100.96.0.0/12 so the API server hands out the new range before we recreate the cluster services.

> HINT: Modify the kubernetes API server pod YAML

<br>
<details><summary>Solution</summary>
<br>

```bash
# change the api server command that hands out service addresses (serviceCIDR) for the cluster
vim /etc/kubernetes/manifests/kube-apiserver.yaml 
```{{exec}}

```yaml
# kube-apiserver.yaml
...
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=172.30.1.2
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction
    - --enable-bootstrap-token-auth=true
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
    - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
    - --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
    - --requestheader-allowed-names=front-proxy-client
    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
    - --requestheader-extra-headers-prefix=X-Remote-Extra-
    - --requestheader-group-headers=X-Remote-Group
    - --requestheader-username-headers=X-Remote-User
    - --secure-port=6443
    - --service-account-issuer=https://kubernetes.default.svc.cluster.local
    - --service-account-key-file=/etc/kubernetes/pki/sa.pub
    - --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
    - --service-cluster-ip-range=100.96.0.0/12   # serviceCIDR used when re-creating default services
    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
...
```


</details>

> NOTE: Once the manifest is saved, the static `kube-apiserver` pod will be restarted automatically with the updated serviceCIDR. Continue to the next step to recreate the core services so they pick up the new range.
