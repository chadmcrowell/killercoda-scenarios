# Step 3 — Apply the Fix

Fix the cluster-wide metrics problem first, then address the per-Deployment misconfiguration.

## Fix 1 — Install metrics-server

Apply the official metrics-server manifest:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```{{exec}}

On kubeadm clusters the kubelet uses self-signed TLS certificates. metrics-server will fail to start without the `--kubelet-insecure-tls` flag. Patch the Deployment to add it:

```bash
kubectl patch deployment metrics-server -n kube-system \
  --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```{{exec}}

Wait for the rollout to complete:

```bash
kubectl rollout status deployment metrics-server -n kube-system
```{{exec}}

Confirm the Metrics API is now registered and available:

```bash
kubectl get apiservice v1beta1.metrics.k8s.io
```{{exec}}

The AVAILABLE column should show `True`. Verify you can now pull live node and pod metrics:

```bash
kubectl top nodes
```{{exec}}

```bash
kubectl top pods
```{{exec}}

Wait about 30 seconds for the HPA controller to pick up the first metrics scrape, then check HPA status:

```bash
kubectl get hpa
```{{exec}}

`api-server-hpa` should now show a real value (e.g., `0%/50%`). `worker-hpa` will still show `<unknown>/50%` — the second problem remains.

## Fix 2 — Add CPU Resource Requests to the Worker Deployment

Patch the `worker` Deployment to add CPU and memory requests. This gives the HPA the baseline it needs to calculate a utilization percentage:

```bash
kubectl patch deployment worker --type=json -p='[
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/resources",
    "value": {
      "requests": {"cpu": "100m", "memory": "64Mi"},
      "limits":   {"cpu": "200m", "memory": "128Mi"}
    }
  }
]'
```{{exec}}

This triggers a rolling update. Watch the new pod roll out:

```bash
kubectl rollout status deployment worker
```{{exec}}

The new `worker` pods now have a CPU request. Wait 30 seconds for the HPA controller to receive the first metrics reading, then check both HPAs:

```bash
kubectl get hpa
```{{exec}}

Both should now show real utilization values:

```text
NAME             REFERENCE               TARGETS    MINPODS   MAXPODS   REPLICAS
api-server-hpa   Deployment/api-server   0%/50%     1         5         1
worker-hpa       Deployment/worker       0%/50%     1         5         1
```

## Verify HPA Health

Check the HPA conditions to confirm both are fully operational:

```bash
kubectl describe hpa api-server-hpa | grep -A15 "Conditions:"
```{{exec}}

```bash
kubectl describe hpa worker-hpa | grep -A15 "Conditions:"
```{{exec}}

Look for these three conditions all showing `True`:

```text
AbleToScale     True   ReadyForNewScale
ScalingActive   True   ValidMetricFound
ScalingLimited  False  DesiredWithinRange
```

`ScalingActive: True` confirms the HPA is reading live metrics and will scale when thresholds are crossed. `ScalingLimited: False` confirms the current replica count is within the min/max bounds.

Inspect the raw current metric values the HPA is reading:

```bash
kubectl get hpa api-server-hpa -o jsonpath='{.status.currentMetrics}{"\n"}'
kubectl get hpa worker-hpa     -o jsonpath='{.status.currentMetrics}{"\n"}'
```{{exec}}

Both HPAs are now healthy and will scale their Deployments up when CPU utilization exceeds 50% of the requested CPU, and back down when it drops below that threshold.
