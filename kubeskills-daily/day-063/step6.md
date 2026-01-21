## Step 6: Test CoreDNS under load

```bash
# Create many DNS queries
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dns-load
spec:
  replicas: 10
  selector:
    matchLabels:
      app: dns-load
  template:
    metadata:
      labels:
        app: dns-load
    spec:
      containers:
      - name: load
        image: busybox
        command:
        - sh
        - -c
        - |
          while true; do
            nslookup nginx.default.svc.cluster.local
            nslookup google.com
            sleep 0.1
          done
EOF

kubectl wait --for=condition=Ready pod -l app=dns-load --timeout=60s

# Check CoreDNS load
sleep 10
kubectl top pod -n kube-system -l k8s-app=kube-dns
```{{exec}}

Generate high DNS query volume and observe CoreDNS load.
