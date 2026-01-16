## Step 2: Create test custom resource

```bash
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: AppTask
metadata:
  name: test-apptask
  namespace: default
spec:
  replicas: 2
  image: nginx:latest
EOF
```{{exec}}

Create a sample AppTask for controllers to reconcile.
