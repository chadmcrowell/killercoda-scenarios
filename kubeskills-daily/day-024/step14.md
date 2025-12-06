## Step 14: Check service type differences

```bash
kubectl get svc web-service
kubectl get svc web-nodeport
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-lb
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

LoadBalancer will remain pending in this environment.
