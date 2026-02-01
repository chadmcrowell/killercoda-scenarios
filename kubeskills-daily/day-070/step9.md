## Step 9: Test VPA configuration

```bash
# VPA requires VPA controller (may not be installed)
cat <<EOF | kubectl apply -f -
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: php-apache-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  updatePolicy:
    updateMode: "Auto"  # Automatically restart pods with new resources
EOF

sleep 10
kubectl get vpa php-apache-vpa 2>&1 || echo "VPA not installed"
```{{exec}}

Create a VPA and check if the controller exists.
