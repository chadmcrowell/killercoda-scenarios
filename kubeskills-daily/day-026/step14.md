## Step 14: Test PodDisruptionBudget with eviction

```bash
cat <<EOF | kubectl apply -f -
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
      - name: app
        image: nginx
        resources:
          requests:
            memory: "50Mi"
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: protected-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: protected
EOF
```{{exec}}

PDB doesn't prevent kubelet evictions (only voluntary disruptions).
