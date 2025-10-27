
### Goal

Create a pod named `non-compliant` using the image `nginx:1.25` that should not run because it violates the `restricted` profile.

Try to achieve this result yourself, then reveal the steps if needed.

<details>
<summary>Show solution</summary>

### Tasks

1. **Create a manifest for an intentionally insecure pod.**

```bash
cat <<'EOF' > non-compliant-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: non-compliant
  namespace: psa-restricted
spec:
  containers:
  - name: web
    image: nginx:1.25
    securityContext:
      privileged: true
EOF
```{{exec}}

2. **Attempt to deploy the pod into the restricted namespace.**

```bash
kubectl apply -f non-compliant-pod.yaml
```{{exec}}

PSA should reject the request with a `restricted` violation message because the container asks for `privileged: true`.

The output will look simlilar to this:
```bash
controlplane:~$ kubectl apply -f non-compliant-pod.yaml
Error from server (Forbidden): error when creating "non-compliant-pod.yaml": pods "non-compliant" is forbidden: violates PodSecurity "restricted:latest": privileged (container "web" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "web" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "web" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "web" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "web" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
```

</details>
