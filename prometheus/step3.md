Create a pod named `restricted-pod` using the `busybox` image that would violate the security policy. 

> HINT: create a [privileged pod](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

<br>
<details><summary>Solution</summary>
<br>

```bash
cat << EOF > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: restricted-pod
  namespace: my-namespace
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "echo Hello Kubernetes! && sleep 3600"]
    securityContext:
      privileged: true
EOF
```{{exec}}

```bash
k create -f pod.yaml
```{{exec}}

The output should be similar to the following:
```bash
Error from server (Forbidden): error when creating "pod.yaml": pods "restricted-pod" is forbidden: violates PodSecurity "restricted:v1.30": privileged (container "busybox" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "busybox" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "busybox" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "busybox" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "busybox" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
```

</details>