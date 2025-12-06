## Step 9: Test API server responsiveness

```bash
time kubectl get nodes
time kubectl get pods -A
time kubectl get all -A > /dev/null
```{{exec}}

Compare response times before and after load.
