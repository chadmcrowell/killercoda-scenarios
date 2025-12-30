## Step 9: Test kubectl version skew

```bash
kubectl version --client --short

echo "kubectl should be within ±1 minor version of the API server"
```{{exec}}

Version skew rules keep kubectl compatible.
