<br>

### Distributed tracing lessons

**Key observations**

- Trace headers must propagate across services; missing propagation cuts traces.
- Sampling drops spans by design; low rates hide traffic.
- Uninstrumented services create gaps even if downstream is traced.
- Collectors under pressure can drop spans; watch buffers/backpressure.
- Multiple context formats exist (W3C, Jaeger, B3); mismatches break links.
- Baggage carries user context alongside trace context.

**Production patterns**

```yaml
env:
- name: OTEL_SERVICE_NAME
  value: my-service
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: http://otel-collector:4317
- name: OTEL_TRACES_SAMPLER
  value: parentbased_traceidratio
- name: OTEL_TRACES_SAMPLER_ARG
  value: "0.1"
- name: OTEL_RESOURCE_ATTRIBUTES
  value: deployment.environment=production
```

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
processors:
  memory_limiter:
    check_interval: 1s
    limit_mib: 512
  batch:
    timeout: 1s
    send_batch_size: 1024
  tail_sampling:
    policies:
      - name: error-traces
        type: status_code
        status_code: {status_codes: [ERROR]}
      - name: slow-traces
        type: latency
        latency: {threshold_ms: 5000}
exporters:
  otlp:
    endpoint: jaeger:4317
  prometheus:
    endpoint: 0.0.0.0:8889
service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, batch, tail_sampling]
      exporters: [otlp, prometheus]
```

**Cleanup**

```bash
pkill -f "port-forward.*jaeger" 2>/dev/null
kubectl delete namespace tracing
kubectl delete deployment service-a service-b-broken service-b-fixed service-c-uninstrumented otel-collector
kubectl delete service service-a service-b service-c otel-collector
kubectl delete pod span-flood baggage-test slow-service 2>/dev/null
kubectl delete configmap otel-config -n tracing
```{{exec}}

---

Next: Day 44 - Debugging Slow Pods with Resource Metrics
