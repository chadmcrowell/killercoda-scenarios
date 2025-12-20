## Step 11: Test LimitRange defaults

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limits
  namespace: resource-test
spec:
  limits:
  - max:
      memory: "512Mi"
    min:
      memory: "64Mi"
    default:
      memory: "256Mi"
    defaultRequest:
      memory: "128Mi"
    type: Container
EOF
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: default-resources
  namespace: resource-test
spec:
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
kubectl get pod default-resources -n resource-test -o jsonpath='{.spec.containers[0].resources}'; echo ""
```{{exec}}

Defaults from the LimitRange should be applied.
