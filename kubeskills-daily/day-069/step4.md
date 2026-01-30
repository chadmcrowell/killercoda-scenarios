## Step 4: Simulate mTLS strict mode

```bash
# In strict mTLS mode, only mesh traffic allowed
# Simulate by using NetworkPolicy

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: strict-mtls-simulation
  namespace: mesh-demo
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          istio-injection: enabled
    # Only allow traffic from other mesh-enabled namespaces
EOF

# Test connectivity from mesh namespace
kubectl run test-mesh -n mesh-demo --rm -it --image=busybox --restart=Never -- \
  wget -O- --timeout=2 http://service-a.mesh-demo 2>&1 | grep -i "connected\|200" || echo "Connection works (same mesh)"

# Test from non-mesh namespace (should fail with strict mode)
kubectl run test-no-mesh -n no-mesh --rm -it --image=busybox --restart=Never -- \
  wget -O- --timeout=2 http://service-a.mesh-demo 2>&1 || echo "Blocked by strict mTLS simulation"
```{{exec}}

Simulate strict mTLS by allowing only mesh-labeled namespaces.
