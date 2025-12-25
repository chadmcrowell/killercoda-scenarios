## Step 12: Check Prometheus configuration

```bash
kubectl exec -n monitoring prometheus-prometheus-0 -- cat /etc/prometheus/config_out/prometheus.env.yaml | head -100
```{{exec}}

Inspect generated scrape configs from ServiceMonitors/PodMonitors.
