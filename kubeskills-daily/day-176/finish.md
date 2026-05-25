## Lab Complete 🎉

**Verification:** Confirm that the Cluster Autoscaler logs show a scale-up event was triggered for the correct node group, that a new node appears in the cluster in a Ready state within a reasonable timeframe, and that the previously Pending pods are successfully scheduled and transition to the Running state.

### What You Learned

The Cluster Autoscaler only scales up when it determines a new node would actually allow a pending pod to be scheduled
Pods with unsatisfiable node selectors or taints cause the autoscaler to skip scale-up because the new node would still not accept the pod
Expander strategy determines which node group gets a new node when multiple groups could satisfy the request
The autoscaler respects minimum and maximum node group size limits configured in the node group settings
Autoscaler logs contain explicit reasons for why scale-up was skipped for each pending pod

### Why It Matters

Teams frequently assume the Cluster Autoscaler is a safety net that will always provide capacity when needed, but this assumption fails in production at exactly the worst moment. When a traffic spike causes dozens of pods to go Pending and the autoscaler silently declines to scale because of a misconfigured node selector, the incident impact is directly tied to how long it takes your team to discover the root cause.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
