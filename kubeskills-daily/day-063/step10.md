## Step 10: Test DNS loop

```bash
# Create loop by forwarding to itself
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
        forward . 127.0.0.1:53
        cache 30
        loop
        reload
    }
EOF

kubectl rollout restart deployment -n kube-system coredns
sleep 15

# Check for loop detection
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=20 | grep -i loop
```{{exec}}

See how the loop plugin detects recursive forwarding.
