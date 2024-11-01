Create a Persistent Volume (PV) named `pv-volume` that has the following specifications:
- a Delete `persistentVolumeReclaimPolicy`
- Uses the strageClass named `local-path`
- Uses `hostPath` volume type, at path `/mnt/data`
- Has a capacity of `1Gi`
- Access mode is set to `ReadWriteOnce`

Once you've created the PV, list all the persistentvolumes in the cluster.

<br>
<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | k apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-volume
spec:
  persistentVolumeReclaimPolicy: Delete
  storageClassName: "local-path"
  hostPath:
    path: "/mnt/data"
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
EOF
```{{exec}}

List the PVs:
```bash
k get pv
```{{exec}}

</details>