## Step 5: Create the missing StorageClass (simulated)

```bash
DEFAULT_PROVISIONER=$(kubectl get storageclass -o jsonpath='{.items[0].provisioner}')
echo "Using provisioner: $DEFAULT_PROVISIONER"

cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: super-fast-nvme
provisioner: $DEFAULT_PROVISIONER
reclaimPolicy: Delete
volumeBindingMode: Immediate
EOF
```{{exec}}

```bash
kubectl get pvc broken-pvc -w
```{{exec}}

```bash
kubectl get pod storage-app
```{{exec}}

PVC should flip from `Pending` to `Bound`, letting the pod become `Running`. Stop the watch once you see it bind.
