## Step 9: Check priority values

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,PRIORITY:.spec.priority,QOS:.status.qosClass
```{{exec}}

Confirm pods show the expected priority values.
