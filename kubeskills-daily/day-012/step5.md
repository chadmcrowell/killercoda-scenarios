## Step 4: Remove load and watch thrashing

Stop the load generator (Ctrl+C) and drop CPU:

```bash
kubectl patch deployment cpu-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"app","args":["-cpus","0"]}]}}}}'
```{{exec}}

Keep watching the HPA and pods:

- Scale-up happens quickly.  
- Scale-down waits for the stabilization window (default 300s).  
- If you reapply load before scale-down completes, you'll see oscillation (thrashing).
