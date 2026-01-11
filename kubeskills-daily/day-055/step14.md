## Step 14: Test RBAC for system components

```bash
# Check kube-system ServiceAccounts
kubectl get sa -n kube-system

# Check permissions for core-dns
kubectl auth can-i list services --as=system:serviceaccount:kube-system:coredns -n kube-system

# Check metrics-server permissions
kubectl auth can-i get nodes --as=system:serviceaccount:kube-system:metrics-server 2>/dev/null || echo "metrics-server SA permissions"
```{{exec}}

System components depend on RBAC; inspect service accounts carefully.
