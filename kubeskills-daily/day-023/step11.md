## Step 11: Test NetworkPolicy enforcement

```bash
kubectl get networkpolicies
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector:
    matchLabels:
      app: nettest
  policyTypes:
  - Ingress
  - Egress
EOF
```{{exec}}

```bash
kubectl exec nettest-1 -- ping -c 2 $(kubectl get pod nettest-2 -o jsonpath='{.status.podIP}') 2>&1 || echo "Blocked by NetworkPolicy"
```{{exec}}

Connectivity should now be blocked if the CNI supports NetworkPolicy.
