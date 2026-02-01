## Step 7: Simulate missing metric labels

```bash
# Metrics without proper labels
cat > /tmp/bad-metrics.txt << 'EOF'
# Bad: No identifying labels
api_calls_total 150

# Good: Labels for filtering
api_calls_total{service="auth", endpoint="/login", status="200"} 150
api_calls_total{service="auth", endpoint="/login", status="401"} 5
EOF

cat /tmp/bad-metrics.txt

echo ""
echo "Without labels:"
echo "- Can't filter metrics by service"
echo "- Can't aggregate properly"
echo "- Hard to debug issues"
```{{exec}}

Proper labels are essential for filtering and aggregation.
