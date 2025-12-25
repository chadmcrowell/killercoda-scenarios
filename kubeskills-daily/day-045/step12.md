## Step 12: Check process tree from debug container

```bash
kubectl debug minimal-app -it --image=busybox --target=app
```{{exec}}

```bash
ps auxf
cat /proc/1/cmdline
ls -la /proc/1/root/
```{{exec}}

Inspect processes and the target container's root filesystem from the debug container.
