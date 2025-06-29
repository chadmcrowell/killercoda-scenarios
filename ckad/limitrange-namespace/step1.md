Create a `LimitRange` that restricts max memory to 512Mi and max CPU to 1 for all pods.

<details><summary>Solution</summary>
<br>

cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-cpu-limit
spec:
  limits:
  - max:
      memory: "512Mi"
      cpu: "1"
    type: Container
EOF
```{{exec}}

</details>