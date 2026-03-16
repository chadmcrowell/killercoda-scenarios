## Lab Complete 🎉

**Verification:** All pods in the deployment should reach Running state without any ErrImagePull or ImagePullBackOff events, and the pod event log should show a successful image pull from the private registry.

### What You Learned

Image pull secrets must exist in the same namespace as the pod that references them
The secret must be of type kubernetes.io/dockerconfigjson and contain a properly formatted auth payload
The imagePullSecrets field in the pod spec must reference the exact secret name or the pull will fail
You can attach an image pull secret to a service account so all pods using that account inherit the credential
Rotating registry credentials requires updating the secret and triggering pod restarts to pick up the new token

### Why It Matters

Registry credential failures are a leading cause of deployment rollout failures in production environments, especially when credentials are rotated on a schedule by a secrets manager but the Kubernetes secret is not updated in sync. During an incident when you need to push a hotfix image, discovering that your pull secret is expired can add critical minutes to your time to resolution.

---
Continue your Kubernetes journey at [KubeSkills Daily](https://killercoda.com/chadmcrowell/course/kubeskills-daily)
