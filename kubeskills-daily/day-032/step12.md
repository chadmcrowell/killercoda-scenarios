## Step 12: Test failed pre-sync hook

```bash
cat > pre-sync-job.yaml << 'HOOK'
apiVersion: batch/v1
kind: Job
metadata:
  name: pre-sync-fail-job
  namespace: default
  annotations:
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: HookSucceeded
spec:
  template:
    spec:
      containers:
      - name: fail
        image: busybox
        command: ['sh', '-c', 'echo "Failing intentionally"; exit 1']
      restartPolicy: Never
  backoffLimit: 0
HOOK

argocd app sync demo-app 2>&1 || echo "Sync blocked by hook failure"
```{{exec}}

Sync should fail until the PreSync hook succeeds.
