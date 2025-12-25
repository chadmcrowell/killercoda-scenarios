## Step 9: Test log rotation

```bash
docker info 2>/dev/null | grep -A 10 "Logging Driver" || echo "Docker not accessible"
# Container logs rotate (commonly 10MB, 3 files); rotated logs are pruned on node.
```{{exec}}

Log rotation on nodes can remove old logs before they are shipped.
