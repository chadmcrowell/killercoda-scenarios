## Step 3: Watch the deadlock

```bash
kubectl get pods -w
```{{exec}}

Both pods stay in `Init:0/1` forever because each waits on the other.
