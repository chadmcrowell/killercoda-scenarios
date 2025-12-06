## Step 12: Check API server request queue

```bash
kubectl get --raw /metrics | grep apiserver_flowcontrol
```{{exec}}

Watch queue lengths, executing requests, and rejected counts.
