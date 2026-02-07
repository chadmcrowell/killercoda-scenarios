## Step 12: Test burst capacity exhaustion

```bash
# Rapid burst of requests
cat > /tmp/burst-test.sh << 'EOF'
#!/bin/bash
# Send 100 requests as fast as possible

start=$(date +%s)

for i in {1..100}; do
  kubectl get ns > /dev/null 2>&1
done

end=$(date +%s)
duration=$((end - start))

echo "100 requests in ${duration}s"
echo "Rate: $((100 / duration)) QPS"
EOF

chmod +x /tmp/burst-test.sh
/tmp/burst-test.sh

echo ""
echo "Burst capacity:"
echo "- Allows short bursts above QPS limit"
echo "- Exhausted burst = throttling"
echo "- Refills over time"
```{{exec}}

Burst capacity allows short spikes above the QPS limit, but once exhausted, requests are throttled until it refills.
