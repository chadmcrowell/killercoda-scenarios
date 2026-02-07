## Step 13: Monitor rate limiting

```bash
# Check API server metrics (if available)
echo "API Server Metrics to monitor:"
echo ""
echo "apiserver_request_total"
echo "- Count of API requests"
echo "- Label: verb, resource, code"
echo ""
echo "apiserver_current_inflight_requests"
echo "- Currently processing requests"
echo ""
echo "apiserver_request_duration_seconds"
echo "- Request latency"
echo ""
echo "apiserver_flowcontrol_rejected_requests_total"
echo "- Requests rejected by APF"
echo ""
echo "apiserver_flowcontrol_request_wait_duration_seconds"
echo "- Time requests waited in queue"
```{{exec}}

Key API server metrics to monitor for rate limiting: request totals, inflight requests, latency, and APF rejections.
