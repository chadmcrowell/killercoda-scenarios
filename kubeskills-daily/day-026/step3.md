## Step 3: Deploy pods with different QoS classes

```bash
cat <<EOF | kubectl apply -f -
# BestEffort - no requests or limits
apiVersion: v1
kind: Pod
metadata:
  name: besteffort-pod
  labels:
    qos: besteffort
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "50M", "--vm-hang", "1"]
---
# Burstable - requests < limits
apiVersion: v1
kind: Pod
metadata:
  name: burstable-pod
  labels:
    qos: burstable
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "50M", "--vm-hang", "1"]
    resources:
      requests:
        memory: "50Mi"
        cpu: "100m"
      limits:
        memory: "200Mi"
        cpu: "500m"
---
# Guaranteed - requests == limits
apiVersion: v1
kind: Pod
metadata:
  name: guaranteed-pod
  labels:
    qos: guaranteed
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "50M", "--vm-hang", "1"]
    resources:
      requests:
        memory: "100Mi"
        cpu: "100m"
      limits:
        memory: "100Mi"
        cpu: "100m"
EOF
```{{exec}}

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,QOS:.status.qosClass
```{{exec}}

Verify QoS classes.
