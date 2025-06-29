Create a pod that drops all Linux capabilities using `securityContext`.

<details><summary>Solution</summary>
<br>

cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: drop-cap
spec:
  containers:
  - name: nginx
    image: nginx
    securityContext:
      capabilities:
        drop: ["ALL"]
EOF
```{{exec}}

</details>