## Step 9: Check APF queue status

```bash
kubectl get --raw /metrics | grep apiserver_flowcontrol_request_queue_length
kubectl get --raw /metrics | grep apiserver_flowcontrol_rejected_requests_total
```{{exec}}

Inspect queue lengths and rejected requests.
