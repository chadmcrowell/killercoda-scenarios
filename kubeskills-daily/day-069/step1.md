## Step 1: Check for existing service mesh

```bash
# Check for Istio
kubectl get namespace istio-system 2>/dev/null && echo "Istio detected" || echo "Istio not installed"

# Check for Linkerd
kubectl get namespace linkerd 2>/dev/null && echo "Linkerd detected" || echo "Linkerd not installed"

# For this lab, we'll simulate mesh behavior
echo "Service mesh concepts demonstration"
```{{exec}}

Detect any existing service mesh namespaces.
