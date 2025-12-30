## Step 8: Partition etcd cluster

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: etcd-partition
spec:
  podSelector:
    matchLabels:
      statefulset.kubernetes.io/pod-name: etcd-0
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          statefulset.kubernetes.io/pod-name: etcd-0
  egress:
  - to:
    - podSelector:
        matchLabels:
          statefulset.kubernetes.io/pod-name: etcd-0
EOF

kubectl exec etcd-1 -- etcdctl --endpoints=http://localhost:2379 put key value 2>&1 && echo "Majority partition: Operational"
kubectl exec etcd-0 -- etcdctl --endpoints=http://localhost:2379 put key2 value2 2>&1 || echo "Minority partition: Failed"
```{{exec}}

Majority (etcd-1/2) continues; isolated etcd-0 cannot write.
