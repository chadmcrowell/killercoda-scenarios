## Step 6: Allow egress from the client

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-client-egress
spec:
  podSelector:
    matchLabels:
      run: client
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: web
    ports:
    - protocol: TCP
      port: 80
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
EOF
```{{exec}}

**Final test:**

```bash
kubectl exec client -- wget -qO- --timeout=2 http://web
```{{exec}}

Success! 🎉
