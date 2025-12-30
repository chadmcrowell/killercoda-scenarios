## Step 12: Test backup hooks

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: db-pod
  namespace: backup-test
  annotations:
    pre.hook.backup.velero.io/container: db
    pre.hook.backup.velero.io/command: '["/bin/bash", "-c", "echo Flushing DB..."]'
    post.hook.backup.velero.io/container: db
    post.hook.backup.velero.io/command: '["/bin/bash", "-c", "echo DB backup complete"]'
spec:
  containers:
  - name: db
    image: postgres:15
    env:
    - name: POSTGRES_PASSWORD
      value: password
EOF

velero backup create backup-with-hooks \
  --include-namespaces backup-test \
  --wait

velero backup logs backup-with-hooks | grep -i hook
```{{exec}}

Hooks run before/after backup for application consistency.
