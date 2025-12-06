## Step 8: Test service without endpoints

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: no-endpoints-svc
spec:
  selector:
    app: nonexistent
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

```bash
kubectl get endpoints no-endpoints-svc
```{{exec}}

```bash
kubectl run test --rm -it --restart=Never --image=curlimages/curl -- curl -m 5 http://no-endpoints-svc
```{{exec}}

Service IP exists but no backends means connection timeouts.
