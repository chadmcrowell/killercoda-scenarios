# Step 2 — Identify the Root Cause

The PVC event told you that `ssd-retain` does not exist. Now confirm what StorageClasses are actually available, understand why the default class did not save you, and pinpoint the exact field in the manifest that caused the problem.

## List Available StorageClasses

```bash
kubectl get storageclass
```{{exec}}

```text
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  8m
```

There is exactly one StorageClass in this cluster: `local-path`. It is marked as the default with the `(default)` annotation. There is no `ssd-retain` class anywhere. The cloud environment where this manifest originated had a cloud block storage provisioner that backed `ssd-retain` — that provisioner does not exist here.

Describe the available StorageClass to understand what it can and cannot do:

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

Two things to note here:

- `ReclaimPolicy: Delete` means if this PVC is deleted, any PersistentVolume and data created for it is also deleted. The original `ssd-retain` name implies it was using `Retain` policy — the team may not have noticed this semantic difference.
- `VolumeBindingMode: WaitForFirstConsumer` means the provisioner waits until a pod is actually scheduled to a node before creating the volume. Until then the PVC will show `Pending` even after the StorageClass issue is fixed — this is expected, not another error.

## Examine the PVC Spec

Pull the full PVC spec to confirm the exact field causing the issue:

```bash
kubectl get pvc gitea-repos -n dev-tools -o yaml
```{{exec}}

```text
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gitea-repos
  namespace: dev-tools
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: ssd-retain
status:
  phase: Pending
```

The `storageClassName: ssd-retain` field is the problem. StorageClass lookup is an exact string match — there is no fuzzy matching, no alias resolution, and no automatic fallback.

## Why the Default StorageClass Did Not Help

A common misconception: if a PVC specifies a StorageClass that does not exist, surely Kubernetes falls back to the default? It does not. The default StorageClass is only consulted when a PVC omits the `storageClassName` field entirely (or explicitly sets it to `""`). Once you set `storageClassName` to any value, Kubernetes treats that as a contract and looks only for that exact class — forever.

Verify the controller is retrying and failing on a loop:

```bash
kubectl get events -n dev-tools --sort-by='.lastTimestamp'
```{{exec}}

```text
LAST SEEN   TYPE      REASON               OBJECT                          MESSAGE
...
4s          Warning   ProvisioningFailed   persistentvolumeclaim/gitea-repos   storageclass.storage.k8s.io "ssd-retain" not found
```

The `persistentvolume-controller` emits this warning repeatedly. Watch it retry live:

```bash
kubectl get events -n dev-tools -w
```{{exec}}

Press `Ctrl+C` after you observe one or two repeating `ProvisioningFailed` events.

## Root Cause Summary

| What the PVC requests | What the cluster has | Result |
|---|---|---|
| `storageClassName: ssd-retain` | No `ssd-retain` StorageClass | `ProvisioningFailed` event, PVC stays `Pending` |
| — | `local-path` (default) | Ignored — default only applies when no class is specified |

**Root cause:** The Gitea deployment manifest was copied from a cloud environment where `ssd-retain` was a valid StorageClass backed by a cloud block storage provisioner with a retain reclaim policy. That class was never created in this cluster. The `local-path` default exists and is functional, but the explicit `storageClassName` field bypasses the default entirely.

**Secondary finding:** The original `ssd-retain` name implies `ReclaimPolicy: Retain`. The available `local-path` class uses `ReclaimPolicy: Delete`. If you are managing real repository data, you should be aware of this difference before choosing your fix strategy.
