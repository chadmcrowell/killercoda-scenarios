## Step 4: Monitor API server request rates

```bash
kubectl get --raw /metrics | grep -E "apiserver_request_total|apiserver_flowcontrol"
kubectl get --raw /metrics | grep apiserver_flowcontrol_rejected_requests_total
```{{exec}}

Watch request totals and rejected requests (429s).
