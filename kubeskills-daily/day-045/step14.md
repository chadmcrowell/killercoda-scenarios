## Step 14: Debug filesystem issues

```bash
kubectl debug minimal-app -it --image=busybox --target=app
```{{exec}}

Inside debug container:
```bash
df -h
mount
ls -la /proc/1/root/
```{{exec}}

Inspect disk usage and the target container's filesystem mounts.
