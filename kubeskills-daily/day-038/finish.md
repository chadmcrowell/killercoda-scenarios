<br>

### DNS resolution lessons

**Key observations**

- CoreDNS outages break DNS immediately; scaling back restores service.
- ndots controls search expansion; high ndots slows short-name lookups.
- dnsConfig options (timeout/attempts) tune failure speed.
- dnsPolicy changes which nameservers/search domains are used.
- NetworkPolicies can block DNS egress; allow kube-system UDP 53.
- Headless services return pod IPs, not a single ClusterIP.

**Production patterns**

```yaml
spec:
  dnsPolicy: ClusterFirst
  dnsConfig:
    options:
    - name: ndots
      value: "2"
    - name: timeout
      value: "2"
    - name: attempts
      value: "2"
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
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

```bash
# Scale CoreDNS horizontally
kubectl scale deployment coredns -n kube-system --replicas=5
# Or adjust vertically
kubectl set resources deployment coredns -n kube-system \
  --limits=cpu=200m,memory=256Mi \
  --requests=cpu=100m,memory=128Mi
```

**Cleanup**

```bash
kubectl delete pod dns-check ndots-test ndots-optimized dns-timeout dns-default dns-clusterfirst dns-none dns-blocked 2>/dev/null
kubectl delete networkpolicy allow-dns 2>/dev/null
kubectl delete deployment cache-test headless 2>/dev/null
kubectl delete service cache-test headless-svc 2>/dev/null
```{{exec}}

---

Next: Day 39 - TBD
