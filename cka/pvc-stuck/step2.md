Now that you've identified the mismatch, fix it.

The PV `broken-pv` supports `ReadWriteOnce`, but `broken-pvc` was created requesting `ReadWriteMany`. Since access modes are immutable after creation, you need to delete the PVC and recreate it with the correct access mode.

Delete the broken PVC:

```bash
kubectl delete pvc broken-pvc -n dev
```{{exec}}

Recreate it with the correct access mode (`ReadWriteOnce`) to match the PV:

```bash
kubectl get pvc broken-pvc -n dev
```{{exec}}

<br>
<details><summary>Solution</summary>
<br>

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: broken-pvc
  namespace: dev
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
EOF
```{{exec}}

Confirm the PVC is now bound:

```bash
kubectl get pvc broken-pvc -n dev
```{{exec}}

The `STATUS` column should show `Bound`.

</details>
