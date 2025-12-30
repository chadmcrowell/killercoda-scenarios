## Step 5: Test version compatibility matrix

```bash
kubectl get nodes -o json | jq -r '.items[] | "\(.metadata.name): \(.status.nodeInfo.kubeletVersion)"'
```

Remember: kube-apiserver is N; kubelet N-2..N; controller-manager/scheduler N-1..N; kubectl N-1..N+1.
