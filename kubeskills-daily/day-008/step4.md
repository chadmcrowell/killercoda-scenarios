## Step 4: Diagnose the issue

```bash
kubectl describe pod storage-app | grep -A 5 Events
```{{exec}}

```bash
kubectl describe pvc broken-pvc | grep -A 5 Events
```{{exec}}

Events call out `persistentvolumeclaim "broken-pvc" not found` on the pod and `storageclass.storage.k8s.io "super-fast-nvme" not found` on the claim—silent Pending now has a root cause.
