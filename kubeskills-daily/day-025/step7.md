## Step 7: Measure API server latency

```bash
time for i in $(seq 1 100); do
  kubectl create configmap test-$i --from-literal=key=value --dry-run=client -o yaml | kubectl apply -f - > /dev/null
done
```{{exec}}

Quickly creating resources gives a rough latency baseline.
