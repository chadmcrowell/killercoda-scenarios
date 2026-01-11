## Step 1: Check Pod Security Admission status

```bash
# Check if PSA is enabled (default in K8s 1.23+)
kubectl api-versions | grep admissionregistration

# Check current namespace labels
kubectl get namespaces default -o yaml | grep pod-security
```{{exec}}

Confirm PSA is enabled and namespaces are labeled.
