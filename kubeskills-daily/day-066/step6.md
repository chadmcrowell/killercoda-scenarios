## Step 6: Add LimitRange to provide defaults

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: quota-test
spec:
  limits:
  - default:  # Default limits
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:  # Default requests
      cpu: "100m"
      memory: "128Mi"
    type: Container
EOF

# Now pod without requests can be created
kubectl delete pod no-requests -n quota-test 2>/dev/null
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: with-defaults
  namespace: quota-test
spec:
  containers:
  - name: app
    image: nginx
    # No resources specified - will use LimitRange defaults
EOF

sleep 10
kubectl get pod with-defaults -n quota-test
kubectl get pod with-defaults -n quota-test -o jsonpath='{.spec.containers[0].resources}'
echo ""
```{{exec}}

Apply a LimitRange so pods get default requests/limits.
