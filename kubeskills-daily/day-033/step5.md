## Step 5: Test without routing rules (random distribution)

```bash
kubectl run -it --rm debug --image=curlimages/curl --restart=Never -- sh -c '
for i in $(seq 1 10); do
  curl -s http://webapp
  sleep 0.5
done
'
```{{exec}}

With no routing rules, kube-service balances randomly across v1 and v2.
