## Step 14: Test observability during incidents

```bash
cat > /tmp/incident-scenario.sh << 'EOF'
#!/bin/bash
echo "=== Incident Scenario ==="

echo -e "\n1. Users report: 'Site is slow'"

echo -e "\n2. Check metrics:"
echo "   - Prometheus down? Can't see metrics"
echo "   - High cardinality? Queries timeout"
echo "   - No retention? Historical data missing"
echo "   - Wrong labels? Can't filter to problem"

echo -e "\n3. Check logs:"
echo "   - Not aggregated? Logs on deleted pods lost"
echo "   - Not indexed? Can't search effectively"
echo "   - Too verbose? Important errors buried"

echo -e "\n4. Check traces:"
echo "   - Sampled out? Can't reproduce user request"
echo "   - Missing spans? Can't see full path"
echo "   - No correlation? Can't link logs to traces"

echo -e "\n5. Result:"
echo "   - Extended MTTR"
echo "   - Blind debugging"
echo "   - Customer impact"
EOF

chmod +x /tmp/incident-scenario.sh
/tmp/incident-scenario.sh
```{{exec}}

Observability gaps extend incident resolution time.
