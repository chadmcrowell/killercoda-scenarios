# Step 2 — Identify the Root Cause

Both HPAs show `<unknown>` but for different reasons. One is a cluster-wide infrastructure gap; the other is a per-Deployment misconfiguration. Investigate each separately.

## Diagnose api-server-hpa: Missing Metrics Server

Describe the HPA and read the Events section:

```bash
kubectl describe hpa api-server-hpa
```{{exec}}

In the **Events** section you'll see a warning like:

```text
Warning  FailedGetResourceMetric  ...
  unable to get metrics for resource cpu:
  unable to fetch metrics from resource metrics API:
  the server could not find the requested resource
```

The HPA controller queries the Kubernetes Metrics API (`metrics.k8s.io`) to read live CPU and memory utilization from pods. If that API isn't registered, every HPA in the cluster returns `<unknown>` for resource metrics.

Confirm the Metrics API is missing:

```bash
kubectl get apiservice v1beta1.metrics.k8s.io
```{{exec}}

The service either doesn't exist or shows `False` in the AVAILABLE column. Check whether metrics-server is deployed at all:

```bash
kubectl get pods -n kube-system | grep metrics
```{{exec}}

No metrics-server pod exists. The Metrics API is unavailable cluster-wide — this is why both HPAs show `<unknown>`.

Verify by trying to pull node metrics directly:

```bash
kubectl top nodes
```{{exec}}

Expected output:

```text
error: Metrics API not available
```

### Root Cause — api-server-hpa: metrics-server is not installed; `metrics.k8s.io` API unavailable

## Diagnose worker-hpa: Missing Resource Requests

Even after metrics-server is running, the `worker-hpa` will still fail. The HPA controller calculates CPU utilization as a **percentage of each pod's requested CPU**. Without a CPU request, it has no denominator for the percentage calculation.

Inspect the resource block on each Deployment's pod spec:

```bash
kubectl get deployment api-server -o jsonpath='{.spec.template.spec.containers[0].resources}{"\n"}'
```{{exec}}

Output: `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}`

```bash
kubectl get deployment worker -o jsonpath='{.spec.template.spec.containers[0].resources}{"\n"}'
```{{exec}}

Output: `{}`

`api-server` pods have `requests.cpu: 100m`. `worker` pods have nothing. Describe the `worker-hpa` to see the specific error that will appear once metrics-server is installed:

```bash
kubectl describe hpa worker-hpa
```{{exec}}

Once metrics-server is running you'll see a condition like:

```text
ScalingActive  False  FailedGetResourceMetric
  the HPA was unable to compute the replica count:
  missing request for cpu in container worker of Pod worker-xxx
```

### Root Cause — worker-hpa: `worker` Deployment has no CPU resource requests; HPA cannot compute a utilization percentage

## Summary of Findings

| HPA             | Symptom          | Root Cause                                          |
|-----------------|------------------|-----------------------------------------------------|
| `api-server-hpa`| `<unknown>/50%`  | metrics-server not installed; Metrics API missing   |
| `worker-hpa`    | `<unknown>/50%`  | Worker pods have no `resources.requests.cpu`        |
