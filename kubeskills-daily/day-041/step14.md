## Step 14: Debug missing targets

```bash
kubectl get servicemonitor -A
kubectl describe servicemonitor correct-label-monitor
kubectl logs -n monitoring -l app.kubernetes.io/name=prometheus --tail=100
kubectl exec -n monitoring prometheus-prometheus-0 -- wget -O- http://metrics-app-svc.default.svc:9113/metrics 2>&1 || echo "Connection failed"
```{{exec}}

Use ServiceMonitor status, Prometheus logs, and direct wget to troubleshoot missing targets.
