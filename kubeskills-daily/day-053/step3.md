## Step 3: Simulate partition with NetworkPolicy

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: partition-policy
spec:
  podSelector:
    matchLabels:
      statefulset.kubernetes.io/pod-name: split-test-0
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          statefulset.kubernetes.io/pod-name: split-test-0
  egress:
  - to:
    - podSelector:
        matchLabels:
          statefulset.kubernetes.io/pod-name: split-test-0
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
EOF

kubectl exec split-test-0 -- curl -m 2 http://$POD_1 2>&1 || echo "0→1: PARTITIONED"
kubectl exec split-test-1 -- curl -m 2 http://$POD_0 2>&1 || echo "1→0: PARTITIONED"
kubectl exec split-test-1 -- curl -m 2 http://$POD_2 > /dev/null 2>&1 && echo "1→2: OK"
```{{exec}}

Pod-0 is isolated by the NetworkPolicy.
