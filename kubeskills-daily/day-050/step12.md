## Step 12: Test PodDisruptionBudget blocking eviction

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: protected-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: protected
  template:
    metadata:
      labels:
        app: protected
    spec:
      containers:
      - name: nginx
        image: nginx
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: protected-pdb
spec:
  minAvailable: 3
  selector:
    matchLabels:
      app: protected
EOF

kubectl wait --for=condition=Ready pods -l app=protected --timeout=60s
kubectl drain $NODE --ignore-daemonsets --delete-emptydir-data --timeout=30s 2>&1 || echo "Drain blocked by PDB!"
```{{exec}}

PDB prevents voluntary evictions when minAvailable cannot be met.
