## Step 3: Describe the pod

```bash
kubectl describe pod blocked-pod
```{{exec}}

Focus on the `Init Containers` section—it shows the init container still Running and blocking the rest of the pod.
