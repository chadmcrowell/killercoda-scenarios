## Step 6: Simulate high etcd load

```bash
for i in $(seq 1 100); do
  kubectl create configmap load-test-$i --from-literal=data=$(date) &
done
wait

kubectl exec -n kube-system $ETCD_POD -- sh -c 'du -sh /var/lib/etcd'
```{{exec}}

Create many ConfigMaps and check etcd data size growth.
