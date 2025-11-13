## Step 2: Apply a default-deny policy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
```{{exec}}

**Test connectivity again:**

```bash
kubectl exec client -- wget -qO- --timeout=2 http://web
```{{exec}}

Request times out—everything is blocked.
