## Step 3: Find the real error

```bash
kubectl get replicaset -n quota-test
```{{exec}}

```bash
kubectl describe replicaset -n quota-test | grep -A 10 Events
```{{exec}}

ReplicaSet events show `failed quota: strict-quota: must specify requests.cpu, requests.memory`—pods are denied until requests are set.
