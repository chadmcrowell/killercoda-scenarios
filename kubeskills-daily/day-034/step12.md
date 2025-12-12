## Step 12: Test privileged pod in isolated namespace

```bash
cat <<'POD' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: privileged-attempt
  namespace: team-a
spec:
  containers:
  - name: bad
    image: nginx
    securityContext:
      privileged: true
POD
```

```bash
kubectl label namespace team-a pod-security.kubernetes.io/enforce=baseline
kubectl delete pod privileged-attempt -n team-a
kubectl apply -f - <<'POD'
apiVersion: v1
kind: Pod
metadata:
  name: privileged-attempt
  namespace: team-a
spec:
  containers:
  - name: bad
    image: nginx
    securityContext:
      privileged: true
POD
```{{exec}}

PSA should block privileged pods after enforcing baseline.
