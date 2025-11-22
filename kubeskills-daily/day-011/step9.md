## Step 9: Create the service and watch init complete

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

Once DNS is available, the init container should exit and the main container will start. Keep watching the pod and logs until it turns Running.
