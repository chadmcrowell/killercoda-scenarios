## Step 12: Voluntary vs involuntary disruptions

PDBs block voluntary disruptions (drain, autoscaler scale-down, eviction API, rolling updates) but not involuntary ones (node crash, OOM kill, `kubectl delete pod --grace-period=0`).

```bash
# This bypasses PDB protections
POD=$(kubectl get pods -l app=critical-app -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $POD --grace-period=0 --force
```{{exec}}
