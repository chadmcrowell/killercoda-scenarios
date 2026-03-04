# Congratulations

You've completed Day 88: **HPA Edge Cases — When Autoscaling Makes Things Worse**.

## What You Learned

- HPA uses the **Kubernetes Metrics API** (`metrics.k8s.io`) to read pod CPU and memory usage — if metrics-server isn't installed, every HPA in the cluster shows `<unknown>` and autoscaling is disabled
- **`kubectl describe hpa`** is the primary debugging tool — the Conditions and Events sections show exactly why metrics aren't being collected and what the HPA controller tried to do
- HPA CPU utilization is calculated as a **percentage of the pod's CPU request** — pods with no `resources.requests.cpu` give the HPA no denominator, so it cannot compute a percentage
- On kubeadm clusters, metrics-server requires `--kubelet-insecure-tls` because kubelet certificates are self-signed and not trusted by default
- `kubectl get apiservice v1beta1.metrics.k8s.io` is a quick way to confirm whether the Metrics API is available in the cluster
- `kubectl top nodes` and `kubectl top pods` failing with `Metrics API not available` is a fast confirmation that metrics-server is the problem
- The three HPA conditions to check after a fix: `AbleToScale`, `ScalingActive`, and `ScalingLimited`

Keep building. See you tomorrow!

— Chad

KubeSkills Daily — Fail Fast, Learn Faster
