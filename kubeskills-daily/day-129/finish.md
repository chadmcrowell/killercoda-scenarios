## Lab Complete 🎉

**Verification:** Confirm that all three pods are in a Running state with all containers reporting ready, that logs from each container show normal operation without errors, and that the main application in the third pod is responding within normal latency thresholds.

### What You Learned

Init containers run sequentially and the main containers do not start until all init containers complete successfully, so a blocked init container silently holds your entire pod in Init state
Each container in a pod has its own resource limits but they all share the same network namespace and can share volume mounts
A crash-looping sidecar triggers the overall pod to show CrashLoopBackOff but only the sidecar container is failing, which you must verify by checking individual container statuses
Use kubectl logs with the container flag to view logs from a specific container in a multi-container pod
CPU throttling in a shared pod can cause the main application to appear slow or unresponsive even though its own metrics look healthy

### Why It Matters

Multi-container pod patterns are foundational to service mesh architectures like Istio and Linkerd, where every production pod runs a sidecar proxy. Misunderstanding how init containers block startup or how resource limits apply per-container can cause you to debug the wrong problem for hours while your on-call incident drags on. CKAD candidates need to be fluent in multi-container pod debugging to pass the exam.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
