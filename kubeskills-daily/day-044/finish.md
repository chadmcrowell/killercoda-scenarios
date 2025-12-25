<br>

### Resource metrics lessons

**Key observations**

- `kubectl top` shows current CPU/memory, refreshed ~60s; no history.
- CPU throttling occurs when usage exceeds limits; cpu.stat shows throttled time.
- Memory over limits triggers immediate OOMKills; nothing is throttled.
- I/O bottlenecks are invisible to metrics-server; use other tools.
- QoS classes (BestEffort/Burstable/Guaranteed) affect scheduling/eviction.
- HPAs rely on metrics-server; missing metrics stall scaling.

**Production patterns**

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

```yaml
resources:
  requests:
    cpu: "1000m"
    memory: "512Mi"
  limits:
    cpu: "2000m"
    memory: "1Gi"
```

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "2Gi"
  limits:
    cpu: "500m"
    memory: "2Gi"
```

**Cleanup**

```bash
kubectl delete pod cpu-bound memory-bound oom-test io-bound besteffort burstable guaranteed multi-container
kubectl delete pod cpu-hog-{1..5} 2>/dev/null
kubectl delete deployment web-app
kubectl delete hpa web-hpa
```{{exec}}

---

Next: Day 45 - kubectl debug and Ephemeral Containers
