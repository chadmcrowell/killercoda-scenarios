## Step 6: Test headless service (direct pod IPs)

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: backend-headless
spec:
  clusterIP: None  # Headless!
  selector:
    app: backend
  ports:
  - port: 8080
    targetPort: 8080
EOF
```{{exec}}

```bash
# Regular service (single ClusterIP)
kubectl run tmp1 --rm -it --restart=Never --image=busybox -- nslookup backend-svc

# Headless service (multiple pod IPs)
kubectl run tmp2 --rm -it --restart=Never --image=busybox -- nslookup backend-headless
```{{exec}}

Headless responses return pod IPs directly; ClusterIP returns a single virtual IP.
