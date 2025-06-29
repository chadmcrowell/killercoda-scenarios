Create a pod with two containers and use `kubectl logs` to access each container’s logs.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: dual-logger
spec:
  containers:
  - name: main
    image: busybox
    command: ["sh", "-c", "while true; do echo main; sleep 5; done"]
  - name: sidecar
    image: busybox
    command: ["sh", "-c", "while true; do echo sidecar; sleep 5; done"]
EOF
```{{exec}}

```bash
kubectl -n session283884 logs dual-logger -c sidecar
```{{exec}}

</details>