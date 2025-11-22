## Step 7: LimitRange violations

```bash
cat <<EOF | kubectl apply -n quota-test -f -
apiVersion: v1
kind: Pod
metadata:
  name: too-big
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: 1000m  # Exceeds LimitRange max!
        memory: 1Gi
EOF
```{{exec}}

Creation fails: error notes CPU max is 500m per LimitRange.
