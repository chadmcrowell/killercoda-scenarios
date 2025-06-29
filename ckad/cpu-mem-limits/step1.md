Create a pod named `limited` in the `session283884` namespace that has CPU request `100m` and limit `200m`, memory request `64Mi` and limit `128Mi`.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: limited
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
EOF
```{{exec}}

</details>