## Step 3: Try to resolve DNS

```bash
kubectl exec client -- nslookup kubernetes.default
```{{exec}}

This also fails. DNS lives in `kube-system`, so it is egress traffic blocked by your default deny.
