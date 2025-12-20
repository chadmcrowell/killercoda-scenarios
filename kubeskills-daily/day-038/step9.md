## Step 9: Test dnsPolicy variations

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dns-default
spec:
  dnsPolicy: Default
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', 'cat /etc/resolv.conf; sleep 3600']
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-clusterfirst
spec:
  dnsPolicy: ClusterFirst
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', 'cat /etc/resolv.conf; sleep 3600']
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
    - 8.8.4.4
    searches:
    - custom.local
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', 'cat /etc/resolv.conf; sleep 3600']
EOF
```{{exec}}

```bash
echo "=== Default ==="
kubectl exec dns-default -- cat /etc/resolv.conf
echo "=== ClusterFirst ==="
kubectl exec dns-clusterfirst -- cat /etc/resolv.conf
echo "=== None ==="
kubectl exec dns-none -- cat /etc/resolv.conf
```{{exec}}

Compare how dnsPolicy changes resolv.conf.
