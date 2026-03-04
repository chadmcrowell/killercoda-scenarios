## Lab Complete 🎉

**Verification:** Confirm that the pod reaches a Running state with all containers showing ready status, that the restart count stops incrementing, and that logs from both the main container and the sidecar container are available and healthy.

### What You Learned

Sidecar containers share the same network namespace and lifecycle as the main container in a pod
A crashing sidecar will cause the entire pod to restart even if the main container is healthy
Resource limits must be set independently for each container in a pod spec
Container ordering in a pod spec does not guarantee startup order unless init containers are used
Using a well-defined readiness probe on the main container can help surface sidecar-induced failures faster

### Why It Matters

Sidecars are used heavily in service mesh architectures and log forwarding pipelines, meaning a misconfigured sidecar can silently degrade production workloads at scale. If you do not set resource limits on sidecars, a runaway logging agent can starve your application of the resources it needs to serve traffic, leading to cascading failures across your entire deployment.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
