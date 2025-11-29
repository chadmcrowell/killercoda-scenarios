## Step 3: Disable at ServiceAccount level

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: no-auto-sa
automountServiceAccountToken: false
---
apiVersion: v1
kind: Pod
metadata:
  name: sa-no-token
spec:
  serviceAccountName: no-auto-sa
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl exec sa-no-token -- ls /var/run/secrets/kubernetes.io/serviceaccount/ 2>&1
```{{exec}}

SA-level `automountServiceAccountToken: false` also blocks token mounting.
