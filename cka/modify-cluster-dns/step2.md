With the API server now serving the new serviceCIDR, change the IP address associated with the cluster's DNS Service by deleting and re-creating the system services so they repopulate inside the new CIDR range. 

The `kube-dns` (CoreDNS) service is the canonical discovery endpoint for every pod in the cluster; any mismatch between its ClusterIP and the DNS IPs pushed to pods will break name resolution. Recreating the `kube-dns` and `kubernetes` services guarantees they receive fresh IPs from the new CIDR before workloads pick up the updated DNS value.

```bash
# get the `kube-dns` and `kubernetes` services
kubectl get svc -A
```

> The `servicecidrs.apiserver.k8s.io` object stores the currently allocated service IP range so that components such as the API server and admission chain have a canonical source of truth. Removing it after you edit the API server manifest forces Kubernetes to recreate the resource with the new CIDR; otherwise, the legacy CIDR would continue to be advertised and the replacement services would fail to receive addresses inside the updated range.

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
kubectl delete servicecidrs.apiserver.k8s.io kubernetes
```{{exec}}

```bash
# create the default kubernetes service so it receives a ClusterIP inside 100.96.0.0/12
cat <<'EOF' | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  name: kubernetes
  namespace: default
  labels:
    component: apiserver
    provider: kubernetes
spec:
  ports:
    - name: https
      port: 443
      protocol: TCP
      targetPort: 6443
  type: ClusterIP
EOF
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

```bash
# confirm that both services now have ClusterIP values inside 100.96.0.0/12 (e.g. 100.96.0.1 and 100.96.0.10)
kubectl get svc -A
```{{exec}}

You should see the default `kubernetes` service recreated with an IP similar to `100.96.0.1` and the `kube-dns` service with the desired `100.96.0.10` IP.


</details>
