## Step 11: Multiple PDBs conflict

```bash
cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: pdb-conflict
spec:
  maxUnavailable: 0  # Zero tolerance!
  selector:
    matchLabels:
      app: critical-app
EOF
```{{exec}}

```bash
kubectl get pdb
```{{exec}}

Both `critical-app-pdb` and `pdb-conflict` select the same pods—the most restrictive (`maxUnavailable: 0`) wins and blocks all disruptions.
