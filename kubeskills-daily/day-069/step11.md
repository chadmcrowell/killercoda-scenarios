## Step 11: Simulate egress gateway failure

```bash
# Egress traffic control
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-external
  namespace: mesh-demo
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector: {}
    # Only allow internal traffic
EOF

# Test external access (blocked)
kubectl run test-egress -n mesh-demo --rm -it --image=busybox --restart=Never -- \
  wget -O- --timeout=2 https://google.com 2>&1 || echo "External traffic blocked"
```{{exec}}

Simulate egress restrictions and failure.
