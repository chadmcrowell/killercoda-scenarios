## Step 5: Exceed the quota

```bash
kubectl scale deployment with-resources -n quota-test --replicas=10
```{{exec}}

```bash
kubectl get deployment with-resources -n quota-test
kubectl get replicaset -n quota-test -l app=with-resources
kubectl describe replicaset -n quota-test -l app=with-resources | tail -15
```{{exec}}

Only 5 pods exist (pod hard limit). Events show `exceeded quota: strict-quota, requested: pods=1, used: pods=5, limited: pods=5`.
