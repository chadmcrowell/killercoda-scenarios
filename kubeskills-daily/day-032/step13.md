## Step 13: Remove failed hook, test sync waves

```bash
rm pre-sync-job.yaml

cat > wave-1.yaml << 'W1'
apiVersion: v1
kind: ConfigMap
metadata:
  name: wave-1
  namespace: default
  annotations:
    argocd.argoproj.io/sync-wave: "1"
data:
  order: "first"
W1

cat > wave-2.yaml << 'W2'
apiVersion: v1
kind: ConfigMap
metadata:
  name: wave-2
  namespace: default
  annotations:
    argocd.argoproj.io/sync-wave: "2"
data:
  order: "second"
W2

argocd app sync demo-app --dry-run
```{{exec}}

Dry-run shows resources applied in wave order.
