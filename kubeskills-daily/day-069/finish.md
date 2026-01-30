<br>

### Service mesh lessons

**Key observations**

- Sidecar injection is controlled by namespace labels.
- Strict mTLS blocks non-mesh traffic by default.
- VirtualService controls routing between service versions.
- DestinationRule defines traffic policies (circuit breaker, TLS).
- Sidecar overhead adds CPU/memory cost to every pod.
- Certificate lifecycle issues can break mTLS.

**Production patterns**

**Istio installation:**
```bash
# Install Istio
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH

# Install with demo profile
istioctl install --set profile=demo -y

# Enable sidecar injection
kubectl label namespace default istio-injection=enabled
```

**Secure namespace with mTLS:**
```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: production
spec:
  mtls:
    mode: STRICT  # Require mTLS for all traffic
---
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: deny-all
  namespace: production
spec:
  {}  # Deny all by default
---
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-frontend
  namespace: production
spec:
  action: ALLOW
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/default/sa/frontend"]
    to:
    - operation:
        methods: ["GET", "POST"]
```

**Traffic management:**
```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
  - reviews
  http:
  - match:
    - headers:
        end-user:
          exact: jason
    route:
    - destination:
        host: reviews
        subset: v2
  - route:
    - destination:
        host: reviews
        subset: v1
      weight: 90
    - destination:
        host: reviews
        subset: v2
      weight: 10
---
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: reviews
spec:
  host: reviews
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 100
        maxRequestsPerConnection: 2
    outlierDetection:
      consecutiveErrors: 5
      interval: 30s
      baseEjectionTime: 30s
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

**Monitoring mesh health:**
```yaml
# Prometheus alerts
- alert: SidecarInjectionFailed
  expr: |
    sum(rate(sidecar_injection_failure_total[5m])) > 0
  annotations:
    summary: "Sidecar injection failures detected"

- alert: MutualTLSConfigurationError
  expr: |
    sum(rate(pilot_conflict_inbound_listener[5m])) > 0
  annotations:
    summary: "mTLS configuration conflicts"

- alert: HighProxyResourceUsage
  expr: |
    container_memory_working_set_bytes{container="istio-proxy"} /
    container_spec_memory_limit_bytes{container="istio-proxy"} > 0.9
  annotations:
    summary: "Proxy sidecar using > 90% memory"
```

**Cleanup**

```bash
kubectl delete namespace mesh-demo no-mesh
rm -f /tmp/mesh-diagnosis.sh
```{{exec}}

---

Next: Day 70 - Autoscaling Failures with HPA and VPA
