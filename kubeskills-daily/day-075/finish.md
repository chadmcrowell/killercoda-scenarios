## Key Observations

✅ **Metrics scraping** - pull model, requires network access
✅ **High cardinality** - kills Prometheus performance
✅ **Log aggregation** - necessary to retain logs
✅ **Trace sampling** - balance data volume vs coverage
✅ **Alert quality** - avoid fatigue with actionable alerts
✅ **Storage** - retention limited by disk space

## Cleanup

```bash
kubectl delete deployment webapp
kubectl delete service webapp metrics-service
kubectl delete pod logger noisy-logger uninstrumented 2>/dev/null
rm -f /tmp/*.txt /tmp/*.yaml /tmp/*.sh /tmp/*.md
```{{exec}}

---

**Congratulations!** You've completed 75 days of Kubernetes failure scenarios!
