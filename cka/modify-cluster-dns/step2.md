With the API server now serving the new serviceCIDR, change the IP address associated with the cluster's DNS Service by deleting and re-creating the system services so they repopulate inside the new CIDR range. 

The `kube-dns` (CoreDNS) service is the canonical discovery endpoint for every pod in the cluster; any mismatch between its ClusterIP and the DNS IPs pushed to pods will break name resolution. Recreating the `kube-dns` and `kubernetes` services guarantees they receive fresh IPs from the new CIDR before workloads pick up the updated DNS value.

```bash
# get the 'kube-dns' and 'kubernetes' services
kubectl get svc -A
```{{exec}}

> The `servicecidrs.networking.k8s.io` object stores the currently allocated service IP range so that components such as the API server and admission chain have a canonical source of truth. Removing it after you edit the API server manifest forces Kubernetes to recreate the resource with the new CIDR; otherwise, the legacy CIDR would continue to be advertised and the replacement services would fail to receive addresses inside the updated range.

```bash
kubectl get servicecidrs
```{{exec}}

<br>
<details><summary>Solution</summary>
<br>

```bash
# delete the existing DNS service that still points to the old CIDR
kubectl -n kube-system delete svc kube-dns
```{{exec}}

```bash
# remove the default 'kubernetes' service that was handed the old ClusterIP
kubectl -n default delete svc kubernetes
```{{exec}}

```bash
# delete the stored serviceCIDR so the apiserver repopulates it with the new range
kubectl delete servicecidrs kubernetes
```{{exec}}

```bash
# create the kube-dns service (CoreDNS) so it also lands in the new CIDR and points to the apiserver
cat <<'EOF' | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  labels:
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: CoreDNS
  name: kube-dns
  namespace: kube-system
spec:
  ports:
  - name: dns
    port: 53
    protocol: UDP
    targetPort: 53
  - name: dns-tcp
    port: 53
    protocol: TCP
    targetPort: 53
  - name: metrics
    port: 9153
    protocol: TCP
    targetPort: 9153
  selector:
    k8s-app: kube-dns
  type: ClusterIP
EOF
```{{exec}}

> NOTE: The kubernetes service gets re-created automatically, so no need to apply the YAML

```bash
# confirm that both services now have ClusterIP values inside 100.96.0.0/12 (e.g. 100.96.0.1 and 100.96.0.10)
kubectl get svc -A
```{{exec}}

You should see the output similar to the following:
```
controlplane:~$ kubectl get svc -A
NAMESPACE     NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes   ClusterIP   100.96.0.1       <none>        443/TCP                  9s
kube-system   kube-dns     ClusterIP   100.99.203.138   <none>        53/UDP,53/TCP,9153/TCP   2s
```

```bash
# capture the new default service IP and the control-plane node IP to add them as Subject Alternative Names on the kube-apiserver cert
NEW_SERVICE_IP=$(kubectl -n default get svc kubernetes -o jsonpath='{.spec.clusterIP}')
# substitute the actual advertise address used in /etc/kubernetes/manifests/kube-apiserver.yaml (e.g., 172.30.1.2)
APISERVER_IP=$(grep -oP '(?<=--advertise-address=)[^\", ]+' /etc/kubernetes/manifests/kube-apiserver.yaml | head -n1)
```{{exec}}

```bash
# backup the existing apiserver certificate/key so kubeadm can write new files
cp /etc/kubernetes/pki/apiserver.crt /etc/kubernetes/pki/apiserver.crt.bak
cp /etc/kubernetes/pki/apiserver.key /etc/kubernetes/pki/apiserver.key.bak
sudo rm /etc/kubernetes/pki/apiserver.crt /etc/kubernetes/pki/apiserver.key
```{{exec}}

```bash
# reissue the apiserver certificate with the current advertise address, the legacy service IP, and the new service IP
kubeadm init phase certs apiserver \
  --apiserver-advertise-address="${APISERVER_IP}" \
  --apiserver-cert-extra-sans="${APISERVER_IP},10.96.0.1,${NEW_SERVICE_IP}"
```{{exec}}

> Regenerating the `apiserver.crt` file ensures the certificate is valid for the freshly issued ClusterIP (for example 100.96.0.1). Include any other SANs currently configured (such as the node IP or 10.96.0.1 for backward compatibility) so existing components continue to trust the API server. Without this step, components that contact the API via `kubernetes.default`—such as your CNI plugin—will fail TLS verification with errors like `certificate is valid for 10.96.0.1 ... not 100.96.0.1`. The static pod automatically restarts when the certificate changes; you can watch `kubectl get pods -n kube-system` until the apiserver comes back to `Running`.

```bash
# restart Canal so the CNI plugin loads the new kubernetes.default service IP
kubectl -n kube-system rollout restart daemonset/canal
```{{exec}}

> Network plugins read `KUBERNETES_SERVICE_HOST` and `KUBERNETES_SERVICE_PORT` once per pod startup. Restarting the Canal daemonset ensures it reaches the API server via 100.96.0.1 instead of the old 10.96.0.1 IP, preventing sandbox creation errors such as `failed to setup network ... dial tcp 10.96.0.1:443: i/o timeout`. If the pod reports a TLS error, confirm `/etc/kubernetes/pki/apiserver.crt` contains the `100.96.0.1` SAN via `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text | grep 100.96.0.1`.


</details>
