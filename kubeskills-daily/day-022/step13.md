## Step 13: Test imagePullPolicy impact

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pull-policy-test
spec:
  containers:
  - name: app
    image: nginx:latest
    imagePullPolicy: Always
EOF
```{{exec}}

Always pulls even if cached; IfNotPresent uses cache; Never only uses local cache.
