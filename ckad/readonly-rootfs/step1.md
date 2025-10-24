Create a pod in the `session283884` that has `readOnlyRootFilesystem` set to true.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: readonly-pod
spec:
  containers:
  - name: nginx
    image: nginx
    securityContext:
      readOnlyRootFilesystem: true
EOF
```{{exec}}

</details>