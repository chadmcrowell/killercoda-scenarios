
<br>

### WELL DONE!

You successfully:

- Reproduced a scenario where pods are stuck in `Pending` due to a `NotReady` worker node
- Used `kubectl describe node` and events to identify the kubelet as the root cause
- Distinguished between "looks like free capacity" and the scheduler's view of node readiness
- Fixed the issue by restarting the kubelet and confirmed all `api` pods reached `Running`

On the CKA exam, node-level failures are a common troubleshooting topic. Always follow the checklist: **node status → kubelet service → kubelet logs → scheduling events**.
