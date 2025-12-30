## Step 2: Check APF configuration

```bash
kubectl get flowschema
kubectl get prioritylevelconfiguration
kubectl get flowschema workload-high -o yaml
```{{exec}}

See FlowSchemas and PriorityLevelConfigurations that shape request flow.
