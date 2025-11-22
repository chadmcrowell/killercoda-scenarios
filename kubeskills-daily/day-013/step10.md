## Step 10: PDB with unhealthy pod handling

```bash
kubectl scale deployment critical-app --replicas=3
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: unhealthy-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: critical-app
  unhealthyPodEvictionPolicy: AlwaysAllow  # K8s 1.26+
EOF
```{{exec}}

Unhealthy pods won't count against the budget and can still be evicted.
