## Step 6: Examine FlowSchemas

```bash
kubectl get flowschemas
kubectl get flowschema system-leader-election -o yaml
kubectl get flowschema workload-high -o yaml
kubectl get flowschema global-default -o yaml
```{{exec}}

Note matchingPrecedence, priorityLevelConfiguration, and distinguisherMethod.
