Create a pod named `limits-pod` without specifying resource limits. Define a `LimitRange` to apply defaults.

<details><summary>Solution</summary>
<br>

cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
spec:
  limits:
  - default:
      cpu: 200m
      memory: 128Mi
    defaultRequest:
      cpu: 100m
      memory: 64Mi
    type: Container
EOF
```{{exec}}

```bash
kubectl -n session283884 run limits-pod --image=busybox --restart=Never -- sleep 3600
```{{exec}}

</details>