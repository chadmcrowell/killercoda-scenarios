## Step 8: Test NetworkPolicy blocking scraping

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: block-monitoring
spec:
  podSelector:
    matchLabels:
      app: metrics-app
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: metrics-app
EOF
```{{exec}}

Targets will go DOWN because Prometheus pods are not allowed.

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-monitoring
spec:
  podSelector:
    matchLabels:
      app: metrics-app
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: monitoring
    ports:
    - protocol: TCP
      port: 9113
EOF
```{{exec}}

Allowing monitoring namespace restores scraping.
