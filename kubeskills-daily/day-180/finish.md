## Lab Complete 🎉

**Verification:** Confirm that all three previously failing pods are now in the Running state, that the Events section for each pod shows a successful image pull without any authentication errors, and that the image pull secrets are correctly referenced either directly in the pod spec or through the service account depending on which fix was applied for each scenario.

### What You Learned

Image pull secrets must exist in the same namespace as the pod that references them
Secrets can be attached to a pod either directly in the pod spec or via the service account that the pod uses
Attaching a pull secret to a service account means all pods using that service account automatically inherit it
The Kubernetes secret type docker-registry stores credentials in the format that the kubelet uses to authenticate with registries
Expired credentials in a secret cause ImagePullBackOff even though the secret object itself still exists and appears healthy

### Why It Matters

ImagePullBackOff failures block all new pod starts for the affected workloads, and when they are caused by expired credentials the fix requires a secret update followed by a pod restart. In a GitOps environment this can be especially disruptive because the secret rotation must happen outside the normal deployment pipeline, and teams without clear runbooks often spend significant time during an incident tracing which secret is stale.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
