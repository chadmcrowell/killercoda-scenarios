Create a ResourceQuota in the `session283884` namespace that limits total pods to 5 and total memory usage to 2Gi in a namespace.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: mem-pod-quota
spec:
  hard:
    pods: "5"
    requests.memory: "2Gi"
EOF
```{{exec}}

</details>