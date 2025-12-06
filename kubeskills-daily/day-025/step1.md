## Step 1: Check etcd pods

```bash
kubectl get pods -n kube-system -l component=etcd
kubectl get endpoints -n kube-system | grep etcd
```{{exec}}

Confirm etcd pods and their endpoints.
