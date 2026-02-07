## Step 1: Check API server rate limit configuration

```bash
# Check API server flags (conceptual)
echo "API Server Rate Limiting:"
echo "- Default: 400 QPS per user"
echo "- Burst: 600 requests"
echo "- Priority and Fairness (APF) controls queuing"
echo ""
echo "Configured via flags:"
echo "  --max-requests-inflight=400"
echo "  --max-mutating-requests-inflight=200"
```{{exec}}

Understand the default API server rate limiting configuration and how Priority and Fairness controls request queuing.
