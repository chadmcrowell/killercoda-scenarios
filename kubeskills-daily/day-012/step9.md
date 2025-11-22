## Step 8: Custom metrics example (conceptual)

```yaml
# Requires prometheus-adapter or a custom metrics API
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: custom-metric-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: cpu-app
  minReplicas: 2
  maxReplicas: 20
  metrics:
  - type: Pods
    pods:
      metric:
        name: http_requests_per_second
      target:
        type: AverageValue
        averageValue: 100  # Keep ~100 RPS per pod
  - type: External
    external:
      metric:
        name: sqs_queue_length
        selector:
          matchLabels:
            queue: orders
      target:
        type: Value
        value: 1000  # Scale if queue exceeds 1000 messages
```

Illustrates combining pod-level and external metrics for richer scaling signals.
