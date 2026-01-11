## Step 10: Test LimitRange defaults

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: capacity-limits
  namespace: capacity-test
spec:
  limits:
  - max:
      cpu: "2"
      memory: "4Gi"
    min:
      cpu: "50m"
      memory: "64Mi"
    default:
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:
      cpu: "100m"
      memory: "128Mi"
    type: Container
EOF

# Deploy pod without resources specified
kubectl run auto-sized -n capacity-test --image=nginx

# Check assigned resources
kubectl get pod auto-sized -n capacity-test -o jsonpath='{.spec.containers[0].resources}'
echo ""
```

LimitRanges inject defaults and enforce min/max limits.
