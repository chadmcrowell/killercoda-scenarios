## Step 4: Examine iptables rules (iptables mode)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: iptables-viewer
spec:
  hostNetwork: true
  containers:
  - name: viewer
    image: nicolaka/netshoot
    command: ['sleep', '3600']
    securityContext:
      privileged: true
EOF
```{{exec}}

```bash
kubectl exec iptables-viewer -- iptables-save | grep -A 10 web-service
```{{exec}}

Look for KUBE-SERVICES, KUBE-SVC-* (service), and KUBE-SEP-* (endpoints).
