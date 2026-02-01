## Step 15: Comprehensive observability checklist

```bash
cat > /tmp/observability-checklist.md << 'EOF'
# Observability Checklist

## Metrics (Prometheus)

### Configuration
- [ ] Prometheus deployed with adequate resources
- [ ] Persistent storage configured
- [ ] Retention period set appropriately
- [ ] Scrape interval configured per service needs
- [ ] Service discovery working

### Instrumentation
- [ ] Applications expose /metrics endpoint
- [ ] Metrics have appropriate labels
- [ ] Cardinality monitored and controlled
- [ ] Standard metrics implemented (RED/USE)
- [ ] Custom business metrics exposed

### Queries
- [ ] Dashboards use efficient queries
- [ ] Recording rules for expensive aggregations
- [ ] Query performance monitored

## Logs (Loki/ELK)

### Collection
- [ ] Log aggregator deployed (Fluentd/Fluent Bit)
- [ ] Logs collected from all pods
- [ ] Logs persisted (not lost on pod deletion)
- [ ] Structured logging used (JSON)

### Storage
- [ ] Adequate storage provisioned
- [ ] Retention policy configured
- [ ] Log rotation in place
- [ ] Compression enabled

### Access
- [ ] Logs searchable and indexed
- [ ] Correlation IDs in logs
- [ ] Log levels used appropriately
- [ ] Sensitive data redacted

## Traces (Jaeger/Tempo)

### Instrumentation
- [ ] Distributed tracing library integrated
- [ ] Trace context propagated
- [ ] All services instrumented
- [ ] Sampling strategy appropriate

### Collection
- [ ] Trace collector deployed
- [ ] Trace storage configured
- [ ] Retention policy set

## Alerts

### Configuration
- [ ] Alerting rules defined
- [ ] Alert severity levels used
- [ ] Runbooks linked
- [ ] Notification channels configured
- [ ] On-call rotation set up

### Quality
- [ ] Alerts are actionable
- [ ] Alert fatigue minimized
- [ ] Alerts grouped appropriately
- [ ] SLO-based alerts implemented

## Dashboards

### Creation
- [ ] Key metrics dashboarded
- [ ] Service-level dashboards
- [ ] Infrastructure dashboards
- [ ] Business metrics dashboards

### Usability
- [ ] Dashboards load quickly
- [ ] Variables for filtering
- [ ] Annotations for deployments
- [ ] Links to runbooks

## Testing

### Validation
- [ ] Metrics scraping tested
- [ ] Log collection verified
- [ ] Traces validated end-to-end
- [ ] Alerts fire correctly
- [ ] Dashboards accurate

### Scenarios
- [ ] Test during incident
- [ ] Verify historical data
- [ ] Test alert notifications
- [ ] Validate runbooks

## Monitoring the Monitoring

- [ ] Prometheus itself monitored
- [ ] Log aggregator health checked
- [ ] Trace collector monitored
- [ ] Alert manager functional
- [ ] Alerting on observability gaps
EOF

cat /tmp/observability-checklist.md
```{{exec}}

Complete observability checklist for production systems.
