## Step 3: Generate moderate API load

```bash
for i in $(seq 1 100); do
  kubectl get pods > /dev/null 2>&1 &
done
wait
echo "Burst complete"
```{{exec}}

Send a quick burst of API requests.
