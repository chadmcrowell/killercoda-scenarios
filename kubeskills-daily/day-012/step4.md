## Step 3: Generate load to trigger scale-up

```bash
# Terminal 2: Generate CPU load
kubectl run load-generator --rm -it --restart=Never --image=busybox -- sh -c '
while true; do
  wget -q -O- http://cpu-app > /dev/null 2>&1 &
done
'
```{{exec}}

Alternative if the app isn't serving HTTP:

```bash
kubectl set env deployment/cpu-app STRESS_CPU=1
kubectl patch deployment cpu-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"app","args":["-cpus","1"]}]}}}}'
```{{exec}}

```bash
kubectl get hpa,pods -l app=cpu-app -w
```{{exec}}

Load should push CPU utilization above target and drive replicas up.
