With the PVC now bound, the Pod should be able to schedule and start. However, because the Pod was created while the PVC was in `Pending` state, it may still be stuck. Delete and recreate the Pod to allow it to pick up the now-bound PVC.

Check the current Pod state:

```bash
kubectl get pod broken-app -n dev
```{{exec}}

If it is still `Pending`, delete it and let it be recreated:

```bash
kubectl delete pod broken-app -n dev
```{{exec}}

```bash
kubectl get pod broken-app -n dev -w
```{{exec}}

<br>
<details><summary>Solution</summary>
<br>

Recreate the Pod after deletion:

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: broken-app
  namespace: dev
spec:
  containers:
  - name: app
    image: busybox:1.28
    command: ["sh", "-c", "while true; do echo running; sleep 5; done"]
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: broken-pvc
EOF
```{{exec}}

Wait for it to reach `Running`:

```bash
kubectl get pod broken-app -n dev -w
```{{exec}}

Final verification:

```bash
kubectl get pvc broken-pvc -n dev
kubectl get pod broken-app -n dev
```{{exec}}

Both should show a healthy state — `Bound` for the PVC and `Running` for the Pod.

</details>
