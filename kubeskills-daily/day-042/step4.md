## Step 4: Check Fluent Bit logs

```bash
kubectl logs -n logging -l app=fluent-bit --tail=50
```{{exec}}

Fluent Bit tails container logs and outputs to stdout.
