## Step 8: Test hook failures

```bash
# Create pre-install hook that fails
mkdir -p broken-app/templates
cat > broken-app/templates/pre-install-hook.yaml << 'EOF'
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-pre-install
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    spec:
      containers:
      - name: pre-install
        image: busybox
        command: ['sh', '-c', 'exit 1']  # Fails!
      restartPolicy: Never
  backoffLimit: 0
EOF

# Uninstall existing release
helm uninstall test-release

# Try to install with failing hook
helm install test-release broken-app --wait --timeout 2m 2>&1 || echo "Hook failed!"

# Check hook status
kubectl get jobs -l app=test-release
```{{exec}}

Hooks can block installs when they fail.
