## Step 5: Allow traffic to web pods

```bash
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web-ingress
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          run: client
    ports:
    - protocol: TCP
      port: 80
EOF
```{{exec}}

```bash
kubectl exec client -- wget -qO- --timeout=2 http://web
```{{exec}}

Still fails because the client cannot make egress connections yet.
