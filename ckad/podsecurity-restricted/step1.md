Label a namespace with `pod-security.kubernetes.io/enforce=restricted` and try to run a privileged pod.

<details><summary>Solution</summary>
<br>

```bash
kubectl label ns session283884 pod-security.kubernetes.io/enforce=restricted --overwrite
```{{exec}}

cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: privileged
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
    securityContext:
      privileged: true
EOF
```{{exec}}

</details>