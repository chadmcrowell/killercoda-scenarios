## Step 2: Check log location on node

```bash
CONTAINER_ID=$(kubectl get pod logger -o jsonpath='{.status.containerStatuses[0].containerID}' | cut -d/ -f3)
echo "Container ID: $CONTAINER_ID"
# Logs live under /var/log/pods/<namespace>_<pod>_<uid>/<container>/*.log
```{{exec}}

Container logs are written on the node filesystem under the pod log directory.
