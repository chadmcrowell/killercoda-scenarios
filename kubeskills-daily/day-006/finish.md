<br>

### Probe doctor

**Key observations**

✅ Liveness failures restart the container immediately.
✅ Readiness only toggles service endpoints—no restart.
✅ Startup probes shield slow apps until they signal ready.
✅ `initialDelaySeconds` + generous timeouts prevent false positives.

**Production guidelines**

Conservative liveness probe (database):

```yaml
livenessProbe:
  tcpSocket:
    port: 5432
  initialDelaySeconds: 60
  periodSeconds: 20
  timeoutSeconds: 10
  failureThreshold: 3
```

Aggressive readiness probe (web server):

```yaml
readinessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 2
  timeoutSeconds: 1
  failureThreshold: 1
```

Startup probe for slow JVM apps:

```yaml
startupProbe:
  httpGet:
    path: /healthz
    port: 8080
  periodSeconds: 10
  failureThreshold: 30
```

**Cleanup**

```bash
kubectl delete pod slow-app slow-app-fixed readiness-test slow-startup
kubectl delete service web-svc
```{{exec}}

---

Next: [Day 7 - Init Container Failures](https://github.com/kubeskills/daily)
