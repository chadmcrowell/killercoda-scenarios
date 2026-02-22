## Step 7: Test StatefulSet scaling

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nginx-headless
spec:
  clusterIP: None
  selector:
    app: nginx-stateful
  ports:
  - port: 80
EOF
```{{exec}}

```bash
kubectl scale statefulset web --replicas=1

sleep 20
```{{exec}}

```bash
kubectl get pods -l app=nginx-stateful

echo ""
echo "Scale down: web-2, then web-1 deleted (reverse order)"
echo "web-0 remains (highest to lowest ordinal)"
```{{exec}}

```bash
kubectl get pvc
echo ""
echo "PVCs for web-1 and web-2 still exist (not deleted)"
```{{exec}}

StatefulSets scale down in reverse ordinal order (web-2 first, then web-1). Crucially, the PVCs for removed pods are retained — data isn't lost on scale-down.
