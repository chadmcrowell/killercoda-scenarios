## Step 2: Create an overly strict PDB

```bash
cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: critical-app-pdb
spec:
  minAvailable: 2  # All replicas must be available!
  selector:
    matchLabels:
      app: critical-app
EOF
```{{exec}}

```bash
kubectl get pdb critical-app-pdb
```{{exec}}

Allowed disruptions is `0`, so no pod can be evicted.
