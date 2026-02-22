## Step 8: Test volume claim deletion

```bash
kubectl delete statefulset web --cascade=orphan

sleep 5
```{{exec}}

```bash
kubectl get pods -l app=nginx-stateful
```{{exec}}

```bash
kubectl get pvc

echo ""
echo "StatefulSet deleted but:"
echo "- Pods still running (orphaned)"
echo "- PVCs still exist"
echo "- Manual cleanup required"
```{{exec}}

```bash
kubectl delete pods -l app=nginx-stateful
```{{exec}}

Deleting a StatefulSet with `--cascade=orphan` leaves pods and PVCs behind. This is useful for zero-downtime migrations, but requires manual cleanup.
