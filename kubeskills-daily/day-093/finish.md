## Lab Complete 🎉

**Verification:** Confirm that the deployment reaches its desired replica count, that the replicaset events no longer show quota exceeded errors, and that the namespace resource quota usage reflects the new steady state accurately.

### What You Learned

Resource quotas enforce limits on the total resources that can be consumed within a namespace
When a quota is exceeded, new pod creation is denied at the API server level with a quota exceeded error
Deployment and ReplicaSet controllers will show the failure in their events even if the deployment status looks healthy
Both resource requests and limits count against quota, not just actual usage
Quota status can be inspected directly to see current usage versus the configured hard limits

### Why It Matters

In shared cluster environments, resource quotas are essential for preventing one team from consuming all cluster resources, but improperly sized quotas regularly cause silent deployment failures that confuse application teams who have no visibility into namespace-level constraints. During high-traffic events or emergency scale-outs, hitting a quota can prevent your application from scaling precisely when it needs to most.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
