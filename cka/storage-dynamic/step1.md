Your cluster has the following StorageClass configured as the default:

```
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false
```

A new team requires a dedicated StorageClass with a `Retain` reclaim policy so their data survives PVC deletion.

Create a `StorageClass` named `local-path-retain` with the following specs:

- Provisioner: `rancher.io/local-path`
- Reclaim policy: `Retain`
- Volume binding mode: `WaitForFirstConsumer`
- **Not** the default StorageClass

<br>
<details><summary>Solution</summary>
<br>

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path-retain
provisioner: rancher.io/local-path
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
EOF
```{{exec}}

Verify it was created:

```bash
kubectl get sc local-path-retain
```{{exec}}

</details>
