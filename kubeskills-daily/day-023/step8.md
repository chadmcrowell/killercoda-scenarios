## Step 8: Compare dnsPolicy variations

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dns-default
spec:
  dnsPolicy: Default
  containers:
  - name: app
    image: busybox
    command: ['sleep', '3600']
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-clusterfirst
spec:
  dnsPolicy: ClusterFirst
  containers:
  - name: app
    image: busybox
    command: ['sleep', '3600']
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-none
spec:
  dnsPolicy: None
  dnsConfig:
    nameservers:
    - 8.8.8.8
    searches:
    - default.svc.cluster.local
  containers:
  - name: app
    image: busybox
    command: ['sleep', '3600']
EOF
```{{exec}}

```bash
kubectl exec dns-default -- cat /etc/resolv.conf
echo "---"
kubectl exec dns-clusterfirst -- cat /etc/resolv.conf
echo "---"
kubectl exec dns-none -- cat /etc/resolv.conf
```{{exec}}

See how DNS configuration changes with dnsPolicy.
