<br>

### Probe tuning lessons

**Key observations**

- Aggressive liveness probes cause unnecessary restarts; startupProbe prevents early kills.
- Readiness controls traffic; failed readiness removes endpoints without restarts.
- Probe types: HTTP, TCP, exec, gRPC; choose based on app behavior.
- High-frequency probes add overhead on large deployments.
- Rolling updates rely on readiness to stop bad versions.
- Graceful shutdown relies on terminationGracePeriodSeconds and preStop.

**Production patterns**

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
  failureThreshold: 2
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 10
  failureThreshold: 3
```

```yaml
startupProbe:
  httpGet:
    path: /actuator/health
    port: 8080
  periodSeconds: 10
  failureThreshold: 30
```

```yaml
livenessProbe:
  exec:
    command: ["pg_isready", "-U", "postgres"]
  initialDelaySeconds: 30
  periodSeconds: 10
```

**Cleanup**

```bash
kubectl delete pod aggressive-probe slow-startup startup-probe-fixed exec-probe tcp-probe grpc-probe tuned-probes custom-health graceful-shutdown
kubectl delete deployment readiness-test probe-overhead rolling-update
kubectl delete service readiness-svc
```{{exec}}

---

Next: Day 47 - StatefulSet Scaling and PV Orphans (Week 7 Finale!)
