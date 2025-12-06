## Step 12: Test privileged namespace exemption

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: psa-privileged
  labels:
    pod-security.kubernetes.io/enforce: "privileged"
EOF
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: anything-goes
  namespace: psa-privileged
spec:
  hostNetwork: true
  hostPID: true
  containers:
  - name: wild-west
    image: nginx
    securityContext:
      privileged: true
EOF
```{{exec}}

Privileged profile allows the pod.
