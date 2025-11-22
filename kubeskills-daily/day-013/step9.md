## Step 9: Single-replica PDB trap

```bash
kubectl scale deployment critical-app --replicas=1
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: single-replica-pdb
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: critical-app
EOF
```{{exec}}

```bash
kubectl get pdb single-replica-pdb
```{{exec}}

Allowed disruptions are `0`—a single replica with `minAvailable: 1` blocks voluntary evictions.
