## Step 13: Test ServiceAccount with imagePullSecrets

```bash
# Create ServiceAccount with pull secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: registry-sa
imagePullSecrets:
- name: my-registry-secret
EOF

# Use ServiceAccount in pod
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sa-pull-secret
spec:
  serviceAccountName: registry-sa
  containers:
  - name: app
    image: private-registry.example.com/app:v1
EOF

# ServiceAccount automatically provides pull secret
kubectl describe pod sa-pull-secret | grep -A 2 "Image Pull Secrets"
```{{exec}}

Attach pull secrets to a ServiceAccount for reuse.
