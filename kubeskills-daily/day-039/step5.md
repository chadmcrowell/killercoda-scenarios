## Step 5: Monitor all QoS classes

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,QOS:.status.qosClass,STATUS:.status.phase
```{{exec}}

See each pod's QoS and status before adding pressure.
