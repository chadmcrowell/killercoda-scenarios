## Step 7: Simulate stale DNS during rolling update

```bash
# Terminal 1: Watch endpoints
kubectl get endpoints backend-svc -w

# Terminal 2: Continuous requests
kubectl run client --rm -it --restart=Never --image=curlimages/curl -- sh -c '
while true; do
  RESP=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 2 http://backend-svc);
  echo "$(date +%H:%M:%S) - HTTP $RESP";
  sleep 0.5;
done
'

# Terminal 3: Trigger rolling update
kubectl set image deployment/backend web=hashicorp/http-echo:latest
```{{exec}}

Watch for brief errors while endpoints churn during the rollout.
