## Lab Complete 🎉

**Verification:** Confirm that all running pods are using the updated configuration values from the ConfigMap, that no pods are still serving the old configuration, and that the rolling restart completed without any downtime to the application.

### What You Learned

ConfigMaps mounted as volumes are eventually updated in running pods through the kubelet sync loop, but this can take up to a few minutes
ConfigMaps consumed as environment variables are baked in at pod startup and will never update without a pod restart
Applications must be designed to re-read configuration files to benefit from volume-mounted ConfigMap updates
A common pattern is to trigger a rolling restart of a deployment after a ConfigMap update to ensure all pods pick up new values
Annotating deployments with a hash of the ConfigMap content can trigger automatic rollouts when the ConfigMap changes

### Why It Matters

Many teams assume that updating a ConfigMap immediately changes application behavior, then spend hours debugging why their configuration change seems to have no effect while the old behavior persists in production. Worse, in a rolling update scenario, some pods may have the new configuration while others still have the old one, creating split-brain behavior that is extremely difficult to diagnose without understanding ConfigMap propagation semantics.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
