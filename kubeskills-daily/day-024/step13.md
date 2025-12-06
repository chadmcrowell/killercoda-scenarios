## Step 13: Test externalTrafficPolicy

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-external
spec:
  type: NodePort
  externalTrafficPolicy: Local
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30081
EOF
```{{exec}}

With Local, traffic only forwards to pods on the receiving node.
