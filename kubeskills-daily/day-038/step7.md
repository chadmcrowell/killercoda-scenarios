## Step 7: Reduce ndots to optimize

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ndots-optimized
spec:
  dnsConfig:
    options:
    - name: ndots
      value: "1"
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', 'cat /etc/resolv.conf; nslookup kubernetes; sleep 3600']
EOF
```{{exec}}

```bash
kubectl exec ndots-optimized -- cat /etc/resolv.conf
```{{exec}}

ndots is set to 1, so short names resolve faster.
