## Lab Complete 🎉

**Verification:** Confirm that the previously failing pod is now in Running state, that the image pull succeeded as shown in pod events, and that you can explain why the cross-namespace secret reference scenario also fails.

### What You Learned

Image pull secrets must be created in the same namespace as the pod that references them
Secrets can be attached directly to a pod spec or to the default service account so all pods inherit them
Kubernetes caches pulled images on nodes, so a credential failure may only surface when the image is not already cached
The dockerconfigjson secret type must follow a specific JSON structure for credentials to be recognized
Rotating registry credentials requires updating the secret data and ensuring running pods can still pull on restart

### Why It Matters

A deployment that works perfectly in staging can fail in production because the image pull secret exists in one namespace but not another, or because a service account token used as a registry credential was rotated. In high-availability setups, new pods that schedule onto nodes without a cached image will fail to start until the credential issue is resolved.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
