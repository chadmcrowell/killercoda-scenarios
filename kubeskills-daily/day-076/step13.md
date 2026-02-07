## Step 13: Test diff detection failure

```bash
# Create resource with generated fields
cat > /tmp/gitops-repo/diff-test.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: diff-test
spec:
  selector:
    app: test
  ports:
  - port: 80
    targetPort: 80
  # Kubernetes adds: clusterIP, sessionAffinity, type
EOF

kubectl apply -f /tmp/gitops-repo/diff-test.yaml -n gitops-test

# Get actual resource
kubectl get service diff-test -n gitops-test -o yaml > /tmp/actual-service.yaml

# Compare
echo "Git manifest vs Cluster:"
diff /tmp/gitops-repo/diff-test.yaml /tmp/actual-service.yaml || echo "Cluster has additional fields"

echo ""
echo "GitOps tools must ignore generated fields"
echo "Otherwise: constant out-of-sync status"
```{{exec}}

See how Kubernetes-generated fields (clusterIP, annotations) cause false drift detection if not properly ignored.
