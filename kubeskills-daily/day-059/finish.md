<br>

### Webhook timeout lessons

**Key observations**

- Webhooks can block everything if misconfigured with failurePolicy: Fail.
- failurePolicy: Ignore keeps the cluster usable during webhook outages.
- Timeouts add latency to every matching request.
- namespaceSelector can exclude critical namespaces.
- Certificate issues can block all webhook operations.
- Deleting a broken webhook may require bypassing admission.

**Production patterns**

```yaml
# Safe webhook configuration
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: production-webhook
webhooks:
- name: validate.production.com
  clientConfig:
    service:
      name: webhook-service
      namespace: webhook-system
      path: /validate
      port: 443
    caBundle: <base64-encoded-ca-cert>
  rules:
  - apiGroups: ["apps"]
    apiVersions: ["v1"]
    operations: ["CREATE", "UPDATE"]
    resources: ["deployments"]
    scope: "Namespaced"
  admissionReviewVersions: ["v1"]
  sideEffects: None
  timeoutSeconds: 5  # Fast timeout
  failurePolicy: Ignore  # Don't block on failure
  namespaceSelector:
    matchExpressions:
    - key: kubernetes.io/metadata.name
      operator: NotIn
      values: ["kube-system", "kube-public", "webhook-system"]
  objectSelector:
    matchExpressions:
    - key: webhook.production.com/skip
      operator: DoesNotExist  # Allow opt-out
```

```yaml
# High-availability webhook service
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webhook-server
  namespace: webhook-system
spec:
  replicas: 3  # High availability
  selector:
    matchLabels:
      app: webhook
  template:
    metadata:
      labels:
        app: webhook
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchLabels:
                app: webhook
            topologyKey: kubernetes.io/hostname
      containers:
      - name: webhook
        image: webhook-server:v1.0
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        readinessProbe:
          httpGet:
            path: /healthz
            port: 8443
            scheme: HTTPS
          initialDelaySeconds: 5
          periodSeconds: 5
```

```yaml
# Monitor webhook performance
- alert: WebhookHighLatency
  expr: |
    histogram_quantile(0.99, 
      rate(apiserver_admission_webhook_admission_duration_seconds_bucket[5m])
    ) > 1
  annotations:
    summary: "Webhook {{ $labels.name }} latency > 1s"

- alert: WebhookHighFailureRate
  expr: |
    rate(apiserver_admission_webhook_rejection_count[5m]) > 0.1
  annotations:
    summary: "Webhook {{ $labels.name }} rejection rate high"
```

```bash
# Emergency webhook deletion
WEBHOOK_NAME=example

# Delete using raw API (bypasses admission)
kubectl delete --raw /apis/admissionregistration.k8s.io/v1/validatingwebhookconfigurations/$WEBHOOK_NAME

# Or for mutating webhooks
# kubectl delete --raw /apis/admissionregistration.k8s.io/v1/mutatingwebhookconfigurations/$WEBHOOK_NAME
```

**Cleanup**

```bash
kubectl delete validatingwebhookconfiguration --all
kubectl delete mutatingwebhookconfiguration --all
kubectl delete deployment webhook-server
kubectl delete service webhook-service
kubectl delete pod --all --grace-period=0 --force 2>/dev/null
```{{exec}}

---

Next: Day 60 - Custom Controller Crashes and Reconciliation Loops
