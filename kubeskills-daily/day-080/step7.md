## Step 7: Test 429 Too Many Requests

```bash
# Simulate rapid API calls
cat > /tmp/spam-api.sh << 'EOF'
#!/bin/bash
for i in {1..1000}; do
  kubectl get pods > /dev/null 2>&1 &
done
wait
EOF

chmod +x /tmp/spam-api.sh

echo "Running API spam test..."
/tmp/spam-api.sh

echo ""
echo "If rate limited, you'll see:"
echo "- 'Waited for X.Xs due to client-side throttling'"
echo "- HTTP 429 responses"
echo "- Requests queued or rejected"
```{{exec}}

When rate limits are exceeded, the API server returns HTTP 429 responses and clients experience throttling delays.
