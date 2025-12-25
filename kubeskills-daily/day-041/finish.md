<br>

### Prometheus missing targets lessons

**Key observations**

- ServiceMonitor labels must match Prometheus selectors or targets stay empty.
- Service port names matter; monitors reference ports by name.
- NetworkPolicies can block scrapes; allow Prometheus namespace/port.
- Namespace selectors limit discovery; patch Prometheus to watch more.
- Relabeling can drop all targets if misused.
- PodMonitor scrapes pods directly when services are awkward.

**Production patterns**

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: app-monitor
  labels:
    prometheus: main
spec:
  selector:
    matchLabels:
      app: myapp
  endpoints:
  - port: metrics
    interval: 30s
    path: /metrics
    scheme: http
```

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
spec:
  serviceMonitorSelector:
    matchLabels:
      prometheus: main
  serviceMonitorNamespaceSelector: {}
  podMonitorSelector:
    matchLabels:
      prometheus: main
  podMonitorNamespaceSelector: {}
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-prometheus
spec:
  podSelector:
    matchLabels:
      app: myapp
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: monitoring
    ports:
    - protocol: TCP
      port: 9090
```

**Cleanup**

```bash
pkill -f "port-forward.*prometheus" 2>/dev/null
kubectl delete namespace monitoring production
kubectl delete servicemonitor --all
kubectl delete podmonitor --all
kubectl delete deployment metrics-app
kubectl delete service metrics-app-svc no-port-name-svc
kubectl delete networkpolicy block-monitoring allow-monitoring
```{{exec}}

---

Next: Day 42 - Logging Pipeline Failures and Lost Logs
