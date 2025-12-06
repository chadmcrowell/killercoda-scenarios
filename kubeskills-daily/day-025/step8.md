## Step 8: Simulate etcd load

```bash
for i in $(seq 1 100); do
  kubectl create secret generic load-secret-$i \
    --from-literal=data=$(head -c 1024 /dev/urandom | base64) &
done
wait

ETCD_POD=$(kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n kube-system $ETCD_POD -- sh -c 'du -sh /var/lib/etcd'
```{{exec}}

Large numbers of objects increase etcd disk usage.
