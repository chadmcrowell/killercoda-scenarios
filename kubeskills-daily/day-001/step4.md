## **✅ Observe the backoff delay**

```bash
kubectl describe pod restart-onfailure | grep -A 10 Events
```{{exec}}

## Check logs from previous container run

Look for the “Back-off restarting failed container” messages.
The delay increases: 10s → 20s → 40s → 80s → 160s → 300s (max).


```bash
kubectl logs restart-onfailure --previous
```{{exec}}

The `--previous` flag shows logs from the last terminated container.

## Key Observations

✅ **Always**: Restarts on any exit (even success). Use for long-running services.
✅ **OnFailure**: Restarts only on non-zero exit codes. Use for Jobs/batch workloads.
✅ **Never**: No restarts. Use for debugging or one-shot init tasks.


> ❗️PRODUCTION TIP: For Jobs, use `restartPolicy: OnFailure` or `Never`. Using `Always` in a Job
will cause it to never complete!

---

Next: [Day 2 - Breaking StatefulSet Ordering](https://github.com/kubeskills/daily)