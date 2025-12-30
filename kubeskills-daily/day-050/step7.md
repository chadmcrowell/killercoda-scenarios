## Step 7: Simulate node NotReady

```bash
kubectl taint nodes $NODE node.kubernetes.io/unreachable:NoExecute --overwrite
kubectl get nodes
kubectl get pods -l app=multi-node -o wide -w
```{{exec}}

```bash
kubectl get pod -l app=multi-node -o jsonpath='{.items[0].spec.tolerations}' | jq '.[] | select(.key=="node.kubernetes.io/unreachable")'
```{{exec}}

Pods are evicted after default tolerationSeconds (~300s) unless overridden.
