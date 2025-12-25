## Step 8: Compare pods with different QoS classes

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: besteffort
spec:
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: burstable
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "500m"
        memory: "512Mi"
EOF
```{{exec}}

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "200m"
        memory: "256Mi"
      limits:
        cpu: "200m"
        memory: "256Mi"
EOF
```{{exec}}

```bash
kubectl top pods besteffort burstable guaranteed
kubectl get pods besteffort burstable guaranteed -o custom-columns=NAME:.metadata.name,QOS:.status.qosClass
```{{exec}}

Compare usage and QoS classes.
