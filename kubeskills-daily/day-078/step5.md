## Step 5: Test dangerous capabilities

```bash
# Container with CAP_SYS_ADMIN
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cap-sys-admin-pod
spec:
  containers:
  - name: app
    image: ubuntu
    command: ['sleep', '3600']
    securityContext:
      capabilities:
        add: ["SYS_ADMIN"]  # Very dangerous!
EOF

kubectl wait --for=condition=Ready pod cap-sys-admin-pod --timeout=60s

echo "CAP_SYS_ADMIN allows:"
echo "- Mount operations"
echo "- Namespace manipulation"
echo "- Container escape techniques"
echo "- BPF program loading"
```{{exec}}

CAP_SYS_ADMIN is one of the most dangerous capabilities - it enables mount operations and namespace manipulation used in escape techniques.
