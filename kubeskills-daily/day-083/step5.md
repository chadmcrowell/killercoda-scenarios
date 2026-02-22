## Step 5: Test pod deletion without graceful shutdown

```bash
kubectl exec web-0 -- sh -c 'echo "Important data" > /usr/share/nginx/html/data.txt'
```{{exec}}

```bash
kubectl exec web-0 -- cat /usr/share/nginx/html/data.txt
```{{exec}}

```bash
kubectl delete pod web-0 --grace-period=0 --force

sleep 10
```{{exec}}

```bash
kubectl wait --for=condition=Ready pod web-0 --timeout=120s
kubectl exec web-0 -- cat /usr/share/nginx/html/data.txt

echo ""
echo "Data persisted because PVC reattached to new pod"
```{{exec}}

Force-deleting a StatefulSet pod skips graceful shutdown, but the PVC reattaches to the replacement pod — persistent storage survives pod recreation.
