## Step 12: Test service type changes

```bash
# Some cloud providers deprecated certain service types
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: test-service
spec:
  type: LoadBalancer
  selector:
    app: test
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl describe service test-service | grep -A 5 "Events:"
```{{exec}}

Service types and cloud provider integrations may change.
