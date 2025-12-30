<br>

### Network partition lessons

**Key observations**

- Nodes/pods can look Ready while partitions block traffic.
- DNS may still resolve; connections time out due to NetworkPolicy isolation.
- Quorum systems (etcd/Raft) keep majority writable; minority goes read-only/unavailable.
- StatefulSets risk duplicates/consistency issues if controllers can't reconcile.
- Healing requires app-level conflict handling; Kubernetes doesn't auto-resolve data conflicts.
- NetworkPolicies can model partitions for testing and training.

**Production patterns**

```yaml
# Zone isolation for testing
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: zone-isolation
spec:
  podSelector: {}
  policyTypes: [Ingress, Egress]
  ingress:
  - from:
    - podSelector:
        matchLabels:
          topology.kubernetes.io/zone: same-zone
  egress:
  - to:
    - podSelector:
        matchLabels:
          topology.kubernetes.io/zone: same-zone
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

```yaml
# Prometheus alert idea
- alert: PossibleNetworkPartition
  expr: (kube_pod_status_phase{phase="Running"} == 1) and on(pod,namespace) (rate(container_network_receive_errors_total[5m]) > 0.1)
```

```bash
# Quorum reminder
echo "Quorum: 3 nodes need 2; 5 nodes need 3. Minority cannot write."
```

**Cleanup**

```bash
kubectl delete statefulset split-test etcd
kubectl delete service split-test-svc etcd-cluster
kubectl delete networkpolicy --all
rm -f /tmp/partition-detection.md
```{{exec}}

---

Next: Day 54 - Certificate Rotation Failures (Week 8 Finale!)
