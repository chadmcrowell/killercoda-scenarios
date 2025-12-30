## Step 8: Generate heavy load (careful!)

```bash
cat > /tmp/api-load.sh << 'EOF'
#!/bin/bash
COUNT=0
while [ $COUNT -lt 500 ]; do
  kubectl get pods -A > /dev/null 2>&1 &
  kubectl get services -A > /dev/null 2>&1 &
  kubectl get deployments -A > /dev/null 2>&1 &
  COUNT=$((COUNT + 3))
  if [ $((COUNT % 50)) -eq 0 ]; then
    echo "Requests sent: $COUNT"
    sleep 0.5
  fi
done
wait
EOF

chmod +x /tmp/api-load.sh
/tmp/api-load.sh
```{{exec}}

```bash
kubectl get pods 2>&1 | grep -i "429\|too many" || true
```{{exec}}

Send sustained load and check for 429 errors.
