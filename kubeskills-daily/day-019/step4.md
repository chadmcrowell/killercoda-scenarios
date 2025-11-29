## Step 4: Override SA setting at pod level

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: override-mount
spec:
  serviceAccountName: no-auto-sa
  automountServiceAccountToken: true  # Override SA setting!
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl exec override-mount -- ls /var/run/secrets/kubernetes.io/serviceaccount/
```{{exec}}

Pod-level setting overrides the ServiceAccount and mounts the token.
