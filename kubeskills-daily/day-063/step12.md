## Step 12: Test external DNS forwarding failure

```bash
# Create config that breaks external DNS
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
        }
        forward . 192.0.2.1
        cache 30
        loop
        reload
    }
EOF

kubectl rollout restart deployment -n kube-system coredns
kubectl wait --for=condition=Ready pod -n kube-system -l k8s-app=kube-dns --timeout=60s

# Internal DNS works
kubectl exec dns-test -- nslookup nginx.default.svc.cluster.local

# External DNS fails (upstream unreachable)
kubectl exec dns-test -- nslookup google.com 2>&1 || echo "External DNS failed"
```{{exec}}

Break external forwarding while keeping internal DNS working.
