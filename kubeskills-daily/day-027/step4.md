## Step 4: Trigger rate limiting deliberately

```bash
for i in $(seq 1 500); do
  kubectl create configmap flood-$i --from-literal=key=value --dry-run=client -o yaml | kubectl apply -f - > /dev/null 2>&1 &
  if [ $((i % 50)) -eq 0 ]; then
    echo "Created $i configmaps"
    wait
  fi
done
wait
```{{exec}}

```bash
kubectl get events | grep -i throttl
```{{exec}}

Expect throttling messages in events if limits are hit.
