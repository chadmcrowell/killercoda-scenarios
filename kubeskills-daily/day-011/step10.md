## Step 10: DNS policy options

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dns-policy-test
spec:
  dnsPolicy: ClusterFirst  # Default: use cluster DNS
  # dnsPolicy: Default      # Use node's DNS
  # dnsPolicy: None         # Custom DNS config only
  dnsConfig:
    options:
    - name: ndots
      value: "2"     # Reduce search domain lookups
    - name: timeout
      value: "2"     # 2 second timeout
    - name: attempts
      value: "3"     # 3 retry attempts
  containers:
  - name: test
    image: busybox
    command: ['sleep', '3600']
EOF
```{{exec}}

```bash
kubectl exec dns-policy-test -- cat /etc/resolv.conf
```{{exec}}

Review how DNS policy and options render into `/etc/resolv.conf`.
