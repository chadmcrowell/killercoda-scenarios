## Step 15: Rate limiting troubleshooting guide

```bash
cat > /tmp/rate-limit-troubleshooting.md << 'OUTER'
# Rate Limiting Troubleshooting Guide

## Symptoms

### kubectl Commands Slow or Failing
- "Waited for X.Xs due to client-side throttling"
- HTTP 429 responses
- Requests queued or rejected

### Controllers Not Reconciling
- "rate limiter has been exceeded"
- "request was throttled"
- "too many requests"

## Diagnosis

### Check Priority Levels
kubectl get prioritylevelconfigurations

### Check Flow Schemas
kubectl get flowschemas

### Check Request Rate
kubectl get --raw /metrics | grep apiserver_request_total

## Common Causes

1. Chatty controllers listing too frequently
2. Too many watch connections
3. Excessive list operations on large resource sets
4. No request batching (creating resources one at a time)
5. Cloud provider API limits

## Tuning

### APF Configuration
- Increase nominalConcurrencyShares for critical workloads
- Configure proper FlowSchemas for important services
- Adjust queue depth and hand size

### API Server Flags
- --max-requests-inflight (default 400)
- --max-mutating-requests-inflight (default 200)

## Best Practices

1. Use shared informers in controllers
2. Implement exponential backoff
3. Cache frequently accessed data
4. Batch operations when possible
5. Use label selectors to reduce scope
6. Monitor API request rates
7. Configure APF for critical workloads
8. Test under load before production
9. Set appropriate rate limits in clients
10. Handle 429 responses gracefully

## Recovery

### Immediate Actions
1. Identify heavy API users
2. Scale back non-critical controllers
3. Reduce watch connections
4. Batch pending operations

### Long-term Solutions
1. Optimize controller efficiency
2. Implement proper caching
3. Configure APF appropriately
4. Monitor and alert on metrics
5. Regular capacity planning
OUTER

cat /tmp/rate-limit-troubleshooting.md
```{{exec}}

Complete rate limiting troubleshooting guide covering symptoms, diagnosis, common causes, tuning, and recovery procedures.
