## Step 8: Apply network policy (requires CNI support)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: netpol-test
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF

# Test connectivity after policy (should fail)
sleep 5
kubectl exec -n netpol-test client -- wget -O- --timeout=2 http://$WEB_IP 2>&1 || echo "Blocked by NetworkPolicy"
```{{exec}}

Apply a deny-all policy and confirm traffic is blocked.
