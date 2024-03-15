For the deployment named `source-ip-app`, change the rollout strategy for a deployment to "Recreate".

<br>
<details><summary>Solution</summary>
<br>

```bash
# edit the deployment and change the rollout strategy to recreate
kubectl edit deploy source-ip-app
```{{exec}}

```yaml
...
# in the deployment yaml, modify the 'strategy'. save and quit to apply the changes!
spec:
  progressDeadlineSeconds: 600
  replicas: 5
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: source-ip-app
  strategy:
    type: Recreate
...
```

```bash
# view the deployment yaml output to verify that the changes were successful
kubectl get deploy source-ip-app -o yaml | grep strategy -A3

```


</details>