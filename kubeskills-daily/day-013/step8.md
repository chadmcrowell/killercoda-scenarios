## Step 8: Test percentage-based PDB

```bash
# Scale up deployment
kubectl scale deployment critical-app --replicas=5
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: critical-app-pdb
spec:
  minAvailable: 60%  # At least 60% must stay up
  selector:
    matchLabels:
      app: critical-app
EOF
```{{exec}}

```bash
kubectl get pdb critical-app-pdb
```{{exec}}

With 5 replicas, 60% means 3 must stay—2 disruptions are allowed.
