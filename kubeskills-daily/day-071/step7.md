## Step 7: Add finalizer to CR

```bash
cat <<EOF | kubectl apply -f -
apiVersion: example.com/v1
kind: WebApp
metadata:
  name: with-finalizer
  finalizers:
  - webapp.example.com/cleanup
spec:
  replicas: 2
  image: nginx
EOF

# Try to delete (will get stuck)
kubectl delete webapp with-finalizer &
DELETE_PID=$!

sleep 10

# Check status (stuck in Terminating)
kubectl get webapp with-finalizer
kubectl describe webapp with-finalizer | grep -A 5 "Finalizers:"

# Kill background delete
kill $DELETE_PID 2>/dev/null
```{{exec}}

Finalizers block deletion until removed by the controller.
