## Step 18: Actual installation

```bash
helm install myapp-release ./myapp --set replicaCount=2
```{{exec}}

Check resources:

```bash
helm list
kubectl get all -l app.kubernetes.io/instance=myapp-release
```{{exec}}
