## Step 13: Test priority override

```bash
kubectl get flowschema system-nodes -o yaml
kubectl get flowschema kube-system-service-accounts -o yaml
```{{exec}}

System components use higher-priority FlowSchemas than regular users.
