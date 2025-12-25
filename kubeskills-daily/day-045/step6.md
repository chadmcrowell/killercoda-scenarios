## Step 6: Debug by copying pod

```bash
kubectl debug minimal-app -it --copy-to=minimal-app-debug --image=busybox
```{{exec}}

```bash
kubectl get pods | grep minimal-app
kubectl describe pod minimal-app-debug
```{{exec}}

Creates a copy of the pod with a busybox container for debugging.
