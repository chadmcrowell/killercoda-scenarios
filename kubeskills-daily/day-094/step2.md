# Step 2 — Identify the Root Cause

The PVC event told you the StorageClass `fast-ssd` does not exist. Now confirm what StorageClasses are actually available in this cluster and pinpoint exactly where the configuration breaks down.

## List Available StorageClasses

```bash
kubectl get storageclass
```{{exec}}

```text
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  10m
```

There is one StorageClass in the cluster: `local-path`. It uses the `rancher.io/local-path` provisioner and is marked as the default. There is no `fast-ssd` StorageClass. The PVC will remain in `Pending` indefinitely because there is no provisioner to satisfy the claim.

Describe the available StorageClass to understand its capabilities:

```bash
kubectl describe storageclass local-path
```{{exec}}

```text
Name:            local-path
IsDefaultClass:  Yes
Annotations:     storageclass.kubernetes.io/is-default-class=true
Provisioner:     rancher.io/local-path
ReclaimPolicy:   Delete
VolumeBindingMode: WaitForFirstConsumer
AllowVolumeExpansion: false
```

`WaitForFirstConsumer` means the provisioner waits until a pod is scheduled to a node before creating the volume — it needs to know which node to place the storage on. This is important: a PVC using `local-path` will stay in `Pending` until a pod that references it gets scheduled.

## Examine the PVC Spec

Review exactly what the PVC is requesting:

```bash
kubectl get pvc postgres-data -n data-tier -o yaml
```{{exec}}

```text
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-data
  namespace: data-tier
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: fast-ssd
status:
  phase: Pending
```

The `storageClassName: fast-ssd` field in the spec is the source of the problem. StorageClass names are an exact string match — there is no fuzzy matching, no fallback to a default, and no error until the provisioner controller checks for the class.

## Understand Why the Default StorageClass Does Not Help

You might expect that Kubernetes would fall back to the default StorageClass if `fast-ssd` is not found. It does not. The default StorageClass is only used when a PVC specifies **no** `storageClassName` field at all (or sets it to `""`). Once a `storageClassName` is explicitly set in the PVC spec, Kubernetes treats that as a binding contract and will never substitute a different class.

Confirm this by checking the current behavior: the PVC has an explicit `storageClassName` and the controller is looking for that exact class:

```bash
kubectl get events -n data-tier --sort-by='.lastTimestamp'
```{{exec}}

```text
LAST SEEN   TYPE      REASON               OBJECT                        MESSAGE
...
9s          Warning   ProvisioningFailed   persistentvolumeclaim/postgres-data   storageclass.storage.k8s.io "fast-ssd" not found
```

The `persistentvolume-controller` emits this warning on a retry loop. It keeps trying to find a provisioner for `fast-ssd` and keeps failing. You can watch this retry live:

```bash
kubectl get events -n data-tier -w
```{{exec}}

Press `Ctrl+C` after you see one or two `ProvisioningFailed` events repeat.

## Root Cause Summary

| What the PVC requests | What the cluster has | Result |
|---|---|---|
| `storageClassName: fast-ssd` | No `fast-ssd` StorageClass | `ProvisioningFailed` event, PVC stays `Pending` |
| — | `local-path` (default) | Ignored — default only applies when no class is specified |

**Root cause:** The PVC `postgres-data` explicitly requests a StorageClass named `fast-ssd` that does not exist in the cluster. The team migrated the workload from a cloud environment where `fast-ssd` was a valid class (backed by a cloud block storage provisioner), but that class was never created on this cluster. The `local-path` default StorageClass exists and is functional, but it is bypassed because the PVC hardcodes the non-existent class name.
