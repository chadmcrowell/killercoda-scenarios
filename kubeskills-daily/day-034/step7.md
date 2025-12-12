## Step 7: Apply NetworkPolicy to isolate Team B

```bash
cat <<'NP' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-other-namespaces
  namespace: team-b
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector: {}  # Only from same namespace
  egress:
  - to:
    - podSelector: {}  # Only to same namespace
  - to:  # Allow DNS
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
NP
```{{exec}}

Restricts Team B traffic to its own namespace (with DNS allowed).
