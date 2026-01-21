## Step 9: Check CNI plugin logs

```bash
# Find CNI plugin pods
CNI_PODS=$(kubectl get pods -n kube-system -l k8s-app=kube-proxy -o name 2>/dev/null || \
           kubectl get pods -n kube-system | grep -E "calico|flannel|cilium" | awk '{print $1}')

if [ -n "$CNI_PODS" ]; then
  echo "CNI plugin pods found"
  for pod in $CNI_PODS; do
    echo "Logs from $pod:"
    kubectl logs -n kube-system $pod --tail=20 2>/dev/null | grep -i "error\|fail\|warn" || echo "No errors found"
  done
else
  echo "CNI plugin pods not found or not accessible"
fi
```{{exec}}

Scan CNI-related pod logs for warnings or errors.
