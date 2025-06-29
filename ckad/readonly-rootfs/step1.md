Create a pod that has `readOnlyRootFilesystem` set to true.

<details><summary>Solution</summary>
<br>

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