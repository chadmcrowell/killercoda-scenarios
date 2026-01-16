## Step 2: Create webhook service (doesn't exist yet)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: webhook-service
  namespace: default
spec:
  selector:
    app: webhook
  ports:
  - port: 443
    targetPort: 8443
    name: webhook
EOF
```{{exec}}

Create the Service that webhook configurations will point to.
