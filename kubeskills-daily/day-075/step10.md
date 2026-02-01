## Step 10: Test metrics query performance

```bash
# Simulate expensive queries
cat > /tmp/expensive-queries.txt << 'EOF'
# Bad: High cardinality query
sum by (user_id) (http_requests_total)

# Bad: Long time range
rate(http_requests_total[7d])

# Good: Aggregated
sum by (service, status) (rate(http_requests_total[5m]))

# Good: Reasonable time range
rate(http_requests_total[5m])
EOF

cat /tmp/expensive-queries.txt

echo ""
echo "Expensive queries cause:"
echo "- Dashboard timeouts"
echo "- Prometheus CPU spikes"
echo "- Other queries delayed"
```{{exec}}

Query efficiency affects overall observability performance.
