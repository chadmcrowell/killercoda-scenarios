## Step 14: Test service ClusterIP routing

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nettest-svc
spec:
  selector:
    app: nettest
  ports:
  - port: 80
    targetPort: 80
EOF
```{{exec}}

```bash
kubectl exec nettest-1 -- curl -m 5 nettest-svc 2>&1 || echo "No web server running"
```{{exec}}

Service routing should resolve to pod IPs even if no web server responds.
