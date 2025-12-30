## Step 11: Test backward compatibility

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: legacy-service
spec:
  selector:
    app: legacy
  ports:
  - port: 80
EOF

kubectl get service legacy-service -o yaml | grep apiVersion
```{{exec}}

Confirm storage and read API version.
