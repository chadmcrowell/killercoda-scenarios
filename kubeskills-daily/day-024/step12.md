## Step 12: Test session affinity

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: sticky-service
spec:
  selector:
    app: web
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 300
  ports:
  - port: 80
    targetPort: 8080
EOF
```{{exec}}

```bash
kubectl run sticky-test --rm -it --restart=Never --image=curlimages/curl -- sh -c '
for i in $(seq 1 10); do
  curl -s http://sticky-service
  sleep 0.5
done
'
```{{exec}}

ClientIP affinity should hit the same backend repeatedly.
