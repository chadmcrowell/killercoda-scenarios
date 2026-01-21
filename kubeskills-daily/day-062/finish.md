<br>

### CNI failure lessons

**Key observations**

- CNI is required for all pod networking.
- Pod CIDR determines each node's IP allocation.
- IP exhaustion blocks new pod creation.
- ContainerCreating often signals CNI failure.
- NetworkPolicies require CNI plugin support.
- Cross-node traffic depends on routing setup.

**Production patterns**

```yaml
# Prometheus alerts
- alert: CNIPluginDown
  expr: up{job="kube-system/calico-node"} == 0
  for: 5m
  annotations:
    summary: "CNI plugin on {{ $labels.node }} is down"

- alert: PodCIDRExhaustion
  expr: |
    (count(kube_pod_info) by (node) / 
     on(node) group_left() node_network_address_size) > 0.9
  annotations:
    summary: "Pod CIDR on {{ $labels.node }} is 90% exhausted"

- alert: PodsStuckInContainerCreating
  expr: |
    count(kube_pod_status_phase{phase="Pending"}) by (namespace) > 5
  for: 10m
  annotations:
    summary: "{{ $value }} pods stuck in Pending/ContainerCreating"
```

```bash
#!/bin/bash
# cni-health-check.sh

echo "Checking CNI health..."

# Check CNI pods running
CNI_PODS=$(kubectl get pods -n kube-system -l k8s-app=calico-node --no-headers 2>/dev/null | wc -l)
NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)

if [ "$CNI_PODS" -lt "$NODE_COUNT" ]; then
  echo "CRITICAL: CNI pods ($CNI_PODS) < nodes ($NODE_COUNT)"
  exit 2
fi

# Check for pending pods with network issues
STUCK_PODS=$(kubectl get pods -A --field-selector status.phase=Pending -o json | \
  jq '[.items[] | select(.status.conditions[]? | .reason == "ContainerCreating")] | length')

if [ "$STUCK_PODS" -gt 5 ]; then
  echo "WARNING: $STUCK_PODS pods stuck in ContainerCreating"
  exit 1
fi

echo "OK: CNI health check passed"
exit 0
```

```yaml
# For clusters running out of IPs, expand pod CIDR
# This requires cluster recreation or careful migration

# kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
networking:
  podSubnet: "10.244.0.0/16"  # Larger range
  serviceSubnet: "10.96.0.0/12"

# Or per-node configuration
# kubectl patch node <node-name> -p '{"spec":{"podCIDR":"10.244.1.0/24"}}'
```

```yaml
# Default deny all in production namespaces
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
---
# Allow DNS
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

**Cleanup**

```bash
kubectl delete deployment ip-exhaustion
kubectl delete pod test-pod-1 test-pod-2 network-test cross-node-1 2>/dev/null
kubectl delete service test-svc
kubectl delete namespace netpol-test
rm -f /tmp/cni-diagnosis.sh
```{{exec}}

---

Next: Day 63 - CoreDNS Failures and DNS Resolution Chaos
