<br>

### Logging pipeline lessons

**Key observations**

- Parser mismatches drop logs silently.
- Buffer limits and backpressure can lose data under high volume.
- Destination outages cause loss unless buffering/retries persist.
- Node log rotation deletes older logs before shipping.
- Multiline events split without proper parsers.
- Sidecars can ship file-based logs separately from stdout.

**Production patterns**

```yaml
[SERVICE]
    Flush         5
    Daemon        Off
    Log_Level     warn
    storage.path  /var/fluent-bit/state

[INPUT]
    Name              tail
    Path              /var/log/containers/*.log
    Parser            docker
    Tag               kube.*
    Mem_Buf_Limit     10MB
    Skip_Long_Lines   On
    Refresh_Interval  10
    storage.type      filesystem

[FILTER]
    Name                kubernetes
    Match               kube.*
    Merge_Log           On
    Keep_Log            Off
    K8S-Logging.Parser  On
    K8S-Logging.Exclude On

[OUTPUT]
    Name                 es
    Match                *
    Host                 elasticsearch
    Port                 9200
    Retry_Limit          5
    storage.total_limit_size 5G
```

```yaml
[INPUT]
    Name              tail
    Path              /var/log/containers/*.log
    Mem_Buf_Limit     50MB
    storage.type      filesystem
    storage.max_chunks_up 128

[OUTPUT]
    Name          forward
    Match         *
    Host          log-aggregator
    Port          24224
    Retry_Limit   False
```

```yaml
[FILTER]
    Name          sampling
    Match         kube.*
    Percentage    10
```

**Cleanup**

```bash
kubectl delete namespace logging
kubectl delete pod logger unparseable-logs log-flood multiline-logs sidecar-logging
```{{exec}}

---

Next: Day 43 - Distributed Tracing Gaps and Missing Spans
