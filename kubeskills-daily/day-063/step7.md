## Step 7: Corrupt CoreDNS configuration

```bash
# Backup current config
kubectl get configmap -n kube-system coredns -o yaml > /tmp/coredns-backup.yaml

# Create broken configuration
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
        health {
            lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
            ttl 30
        }
        prometheus :9153
        forward . /etc/resolv.conf INVALID_SYNTAX_HERE
        cache 30
        loop
        reload
        loadbalance
    }
EOF

# Restart CoreDNS to pick up config
kubectl rollout restart deployment -n kube-system coredns

# Wait and check status
sleep 15
kubectl get pods -n kube-system -l k8s-app=kube-dns
```{{exec}}

Apply a broken Corefile and watch CoreDNS fail.
