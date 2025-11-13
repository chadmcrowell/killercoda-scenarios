<br>

### Great debugging!

**Key observations**

✅ OOMKill happens instantly—container dies mid-operation.
✅ Exit code 137 is the canonical signal for OOM issues.
✅ QoS classes determine eviction priority.

**Production tips**

Set both requests and limits for predictable behavior:

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "200m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

For burstable web workloads, use low requests and higher limits. For consistent services (databases), keep requests == limits to stay in Guaranteed QoS.

**Cleanup**

```bash
kubectl delete pod memory-hog memory-guaranteed memory-besteffort
```{{exec}}

---

Next: [Day 4 - Network Policy Lockouts](https://github.com/kubeskills/daily)
