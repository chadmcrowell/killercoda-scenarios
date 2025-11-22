## Step 5: Fix the PDB to allow 1 disruption

```bash
cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: critical-app-pdb
spec:
  maxUnavailable: 1  # Allow 1 pod to be down
  selector:
    matchLabels:
      app: critical-app
EOF
```{{exec}}

```bash
kubectl get pdb critical-app-pdb
```{{exec}}

Allowed disruptions should now be `1`.
