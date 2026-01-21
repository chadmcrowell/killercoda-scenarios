## Step 5: Test quota without resource requests

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-requests
  namespace: quota-test
spec:
  containers:
  - name: app
    image: nginx
    # No resource requests specified!
EOF

# Rejected because quota requires requests
sleep 5
kubectl describe pod no-requests -n quota-test 2>&1 | grep -A 5 "Events:"
```{{exec}}

Confirm that quota blocks pods without requests.
