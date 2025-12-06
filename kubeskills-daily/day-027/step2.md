## Step 2: Make baseline API requests

```bash
time kubectl get pods

for i in $(seq 1 10); do
  time kubectl get pods > /dev/null 2>&1
done
```{{exec}}

Measure typical latency before flooding.
