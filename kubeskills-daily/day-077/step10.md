## Step 10: Secret visible in pod spec

```bash
# Create pod with secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pod-spec-secret
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: PASSWORD
      value: "hardcoded-secret-123"  # BAD!
EOF

# Secret visible in pod spec
kubectl get pod pod-spec-secret -o yaml | grep -A 2 "PASSWORD"

echo "Hardcoded secrets in manifests:"
echo "- Visible in Git"
echo "- Visible in cluster"
echo "- Visible to anyone with kubectl access"
```{{exec}}

Hardcoded secrets in pod specs are visible to anyone who can describe or get the pod definition.
