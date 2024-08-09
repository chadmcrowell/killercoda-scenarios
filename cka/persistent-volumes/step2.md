Create a Persistent Volume Claim (PVC) named `pvc-claim` that has the following specifications:
- Uses the storageClass named `local-path`
- Access mode set to `ReadWriteOnce`
- Requests `1Gi` of storage

Once you've created the PVC, list all the persistentvolumeclaims in the cluster.

<br>
<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | k apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-claim
  namespace: default
spec:
  storageClassName: "local-path"
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF
```{{exec}}

```bash
k get pvc -n default
```{{exec}}

</details>