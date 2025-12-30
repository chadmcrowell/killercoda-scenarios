## Step 7: Test as different user (simulate)

```bash
kubectl create serviceaccount load-test-sa
TOKEN=$(kubectl create token load-test-sa --duration=1h)
for i in $(seq 1 50); do
  kubectl --token=$TOKEN get pods > /dev/null 2>&1 &
done
wait
```{{exec}}

Simulate requests from a specific user/service account.
