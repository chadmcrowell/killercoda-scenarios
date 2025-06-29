Create a ServiceAccount named `build-bot` in the `session283884` namespace. Attach it to a pod.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create serviceaccount build-bot
```{{exec}}

cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sa-pod
spec:
  serviceAccountName: build-bot
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
EOF
```{{exec}}

</details>