## Step 9: Test webhook timeout cascades

```bash
# Webhook with slow response
echo "Webhook rate limiting:"
echo "- Webhook takes 10s to respond"
echo "- API server times out"
echo "- Retries add to queue"
echo "- Cascading delays"
echo ""
echo "Symptoms:"
echo "- Pod creation delayed"
echo "- Admission webhook timeouts"
echo "- Resources stuck pending"
```{{exec}}

Slow admission webhooks cause cascading delays as retries pile up in the API server request queue.
