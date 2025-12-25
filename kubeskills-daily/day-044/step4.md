## Step 4: Check CPU throttling

```bash
kubectl exec cpu-bound -- cat /sys/fs/cgroup/cpu/cpu.stat 2>/dev/null || \
kubectl exec cpu-bound -- cat /sys/fs/cgroup/cpu.stat 2>/dev/null || \
echo "CGroup stats not accessible"

kubectl top pod cpu-bound --containers
```{{exec}}

Inspect cgroup cpu.stat and per-container metrics to see throttling counters.
