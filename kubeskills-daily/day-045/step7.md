## Step 7: Debug with modified command

```bash
kubectl debug minimal-app -it --copy-to=minimal-debug-2 --container=app --image=busybox -- sh
```{{exec}}

Copies the pod and overrides the app container with busybox + shell.
