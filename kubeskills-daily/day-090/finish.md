# Congratulations

You've completed Day 90: **Multi-Container Pod Sidecar Failure Debugging**.

## What You Learned

- All containers in a pod share the same network namespace and volume mounts — but have **independent crash/restart behavior**; a crashing sidecar causes the entire pod to restart even when the main container is healthy
- `kubectl logs <pod> -c <container>` is required to read a specific container's logs in a multi-container pod — without `-c`, kubectl uses the first container
- `kubectl logs --previous` reads logs from the **last terminated** instance of a container — essential for diagnosing crash loops where the container restarts before you can read its logs
- A sidecar that references a volume path must have that volume explicitly listed in its own `volumeMounts` — volumes are not automatically shared to all containers
- `kubectl describe pod` → Containers section shows per-container `State`, `Last State`, `Exit Code`, `Restart Count`, and `Ready` — enough to identify exactly which container is failing and why
- Sidecars should always have **resource limits** set lower than the main container to prevent a runaway log agent or proxy from starving the application
- The three core multi-container patterns: **sidecar** (augments), **ambassador** (proxies), **adapter** (transforms)

## Why It Matters

Sidecars are used in service mesh architectures (Envoy proxies), log forwarding pipelines (Fluentd, Filebeat), and metrics exporters. A misconfigured sidecar silently degrades production workloads at scale. If you don't set resource limits on sidecars, a log agent processing a traffic spike can consume all node memory and trigger cascading failures across every pod on that node.

Keep building. See you tomorrow!

— Chad

KubeSkills Daily — Fail Fast, Learn Faster
