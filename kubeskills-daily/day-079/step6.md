## Step 6: Test image without vulnerability scanning

```bash
# Deploy without scanning
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: unscanned-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: unscanned
  template:
    metadata:
      labels:
        app: unscanned
    spec:
      containers:
      - name: app
        image: nginx:1.14  # Old version with known CVEs!
EOF

echo "Nginx 1.14 has known vulnerabilities:"
echo "- CVE-2019-9511: HTTP/2 DoS"
echo "- CVE-2019-9513: HTTP/2 DoS"
echo "- CVE-2019-9516: HTTP/2 DoS"
echo ""
echo "Without scanning, these go undetected"
```{{exec}}

Deploying old images without vulnerability scanning leaves known CVEs running in production undetected.
