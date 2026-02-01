## Step 4: Test high cardinality metrics

```bash
# Simulate metrics with high cardinality
cat > /tmp/high-cardinality.txt << 'EOF'
# Bad: Unique label per request
http_requests_total{user_id="12345", request_id="abc123"} 1
http_requests_total{user_id="67890", request_id="def456"} 1
# Creates millions of time series!

# Good: Aggregate by endpoint
http_requests_total{endpoint="/api/users", status="200"} 1500
EOF

cat /tmp/high-cardinality.txt

echo ""
echo "High cardinality causes:"
echo "- Prometheus OOM"
echo "- Slow queries"
echo "- Storage exhaustion"
```{{exec}}

High cardinality metrics cause performance issues.
