## Step 11: Test with resource hooks

```bash
cat > pre-sync-job.yaml << 'HOOK'
apiVersion: batch/v1
kind: Job
metadata:
  name: pre-sync-job
  namespace: default
  annotations:
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: HookSucceeded
spec:
  template:
    spec:
      containers:
      - name: pre-sync
        image: busybox
        command: ['sh', '-c', 'echo "Running pre-sync"; sleep 5; exit 0']
      restartPolicy: Never
  backoffLimit: 0
HOOK

argocd app sync demo-app
```{{exec}}

Pre-sync job runs before deploying other resources.
