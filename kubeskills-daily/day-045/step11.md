## Step 11: Debug with custom environment

```bash
kubectl debug minimal-app -it --image=busybox --target=app --env="DEBUG=true" --env="VERBOSE=1"
```{{exec}}

Pass env vars into the ephemeral debug container.
