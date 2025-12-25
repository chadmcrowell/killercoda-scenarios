## Step 3: Use kubectl debug with ephemeral container

```bash
kubectl debug minimal-app -it --image=busybox --target=app
```{{exec}}

Inside busybox, you share the pod's process namespace; `ps aux` shows both containers. Type `exit` to leave.
