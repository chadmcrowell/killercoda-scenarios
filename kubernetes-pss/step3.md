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


</details>