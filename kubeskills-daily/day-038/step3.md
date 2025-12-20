## Step 3: Check pod DNS configuration

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dns-check
spec:
  containers:
  - name: test
    image: busybox
    command: ['sleep', '3600']
EOF

kubectl exec dns-check -- cat /etc/resolv.conf
```{{exec}}

Resolv.conf shows CoreDNS ClusterIP as nameserver, search domains, and ndots (usually 5).
