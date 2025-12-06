## Step 3: Test service from within cluster

```bash
kubectl run test-client --rm -it --restart=Never --image=curlimages/curl -- sh -c '
for i in $(seq 1 10); do
  curl -s http://web-service
  sleep 0.5
done
'
```{{exec}}

Responses should round-robin across backend pods.
