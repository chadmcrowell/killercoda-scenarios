## Step 3: Check default tolerations

```bash
kubectl get pod $(kubectl get pods -l app=default-app -o jsonpath='{.items[0].metadata.name}') -o yaml | grep -A 10 tolerations
```{{exec}}

Pods automatically tolerate `node.kubernetes.io/not-ready` and `unreachable` for 300s.
