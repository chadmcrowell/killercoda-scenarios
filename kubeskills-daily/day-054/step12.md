## Step 12: Test certificate monitoring

```bash
cat > /tmp/check-certs.sh << 'EOF'
#!/bin/bash
echo "Checking all certificates..."

kubectl get certificate -A -o json | jq -r '
  .items[] |
  "\(.metadata.namespace)/\(.metadata.name): \(.status.notAfter // "Unknown")"
'

WEEK_FROM_NOW=$(date -d "+7 days" +%s 2>/dev/null || date -v +7d +%s)

kubectl get certificate -A -o json | jq -r --arg week "$WEEK_FROM_NOW" '
  .items[] |
  select(.status.notAfter != null) |
  select(((.status.notAfter | fromdateiso8601) < ($week | tonumber))) |
  "WARNING: \(.metadata.namespace)/\(.metadata.name) expires soon: \(.status.notAfter)"
'
EOF

chmod +x /tmp/check-certs.sh
/tmp/check-certs.sh
```{{exec}}

Simple script to list certs and warn about near-expiry.
