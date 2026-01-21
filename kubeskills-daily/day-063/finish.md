<br>

### CoreDNS failure lessons

**Key observations**

- CoreDNS is critical for all service discovery.
- Pods use the kube-dns ClusterIP from resolv.conf.
- ndots causes multiple search queries before external lookup.
- Forwarding controls external DNS resolution.
- The loop plugin detects recursive forwarding loops.
- Cache improves performance but can serve stale records.

**Production patterns**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coredns
  namespace: kube-system
spec:
  replicas: 3  # At least 2 for HA
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
  selector:
    matchLabels:
      k8s-app: kube-dns
  template:
    metadata:
      labels:
        k8s-app: kube-dns
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchLabels:
                  k8s-app: kube-dns
              topologyKey: kubernetes.io/hostname
      priorityClassName: system-cluster-critical
      containers:
      - name: coredns
        image: coredns/coredns:1.10.1
        resources:
          requests:
            cpu: 100m
            memory: 70Mi
          limits:
            cpu: 500m
            memory: 170Mi
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 60
          timeoutSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready
            port: 8181
```

```text
.:53 {
    errors
    health {
        lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
        ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf {
        max_concurrent 1000
    }
    cache 30
    loop
    reload
    loadbalance round_robin
}
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: optimized-dns
spec:
  dnsConfig:
    options:
    - name: ndots
      value: "1"  # Reduce from default 5
    - name: timeout
      value: "2"
    - name: attempts
      value: "2"
  containers:
  - name: app
    image: myapp:latest
```

```yaml
# Prometheus alerts
- alert: CoreDNSDown
  expr: up{job="kube-dns"} == 0
  for: 5m
  annotations:
    summary: "CoreDNS is down"

- alert: CoreDNSHighLatency
  expr: |
    histogram_quantile(0.99,
      rate(coredns_dns_request_duration_seconds_bucket[5m])
    ) > 0.5
  annotations:
    summary: "CoreDNS latency > 500ms"

- alert: CoreDNSHighErrorRate
  expr: |
    rate(coredns_dns_responses_total{rcode="SERVFAIL"}[5m]) > 10
  annotations:
    summary: "CoreDNS SERVFAIL rate high"
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dnsutils
spec:
  containers:
  - name: dnsutils
    image: registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3
    command:
      - sleep
      - "infinity"
```

**Cleanup**

```bash
kubectl delete deployment dns-load nginx
kubectl delete service nginx
kubectl delete pod dns-test
rm -f /tmp/coredns-backup.yaml /tmp/dns-diagnosis.sh
```{{exec}}

---

Next: Day 64 - Persistent Volume Provisioning Failures
