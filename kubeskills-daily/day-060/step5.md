## Step 5: Check API server load from controller

```bash
# Count requests from controller
kubectl get --raw /metrics | grep apiserver_request_total | grep example.com

# Controller makes requests every 2 seconds indefinitely
```{{exec}}

Observe how a bad controller drives continuous API requests.
