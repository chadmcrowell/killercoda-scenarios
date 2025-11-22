## Step 5: Check the volume mount update

```bash
kubectl exec config-test -- cat /config/config.json
```{{exec}}

The mounted file reflects the new data (`feature_flag: true`, `max_connections: 500`) after the kubelet sync delay.
