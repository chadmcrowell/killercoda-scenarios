## Step 7: Test image tag mismatch

```bash
# Git has one image tag
cat > /tmp/gitops-repo/image-test.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
      - name: app
        image: nginx:1.21  # Old version in Git
EOF

kubectl apply -f /tmp/gitops-repo/image-test.yaml -n gitops-test

# Manually update cluster to different tag
kubectl set image deployment/app-v1 app=nginx:1.22 -n gitops-test

# Cluster now drifted from Git
kubectl get deployment app-v1 -n gitops-test -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
echo "Expected: nginx:1.21 (from Git)"
echo "Actual: nginx:1.22 (manual change)"
echo "Cluster has drifted from Git!"
```{{exec}}

Demonstrate how manual changes to the cluster cause drift from the desired state in Git.
