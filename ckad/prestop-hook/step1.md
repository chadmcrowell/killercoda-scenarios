Create a pod in the `session283884` namespace with a `preStop` lifecycle hook that sleeps for 10 seconds before termination. Use image `nginx`.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: prestop
spec:
  containers:
  - name: nginx
    image: nginx
    lifecycle:
      preStop:
        exec:
          command: ["sleep", "10"]
EOF
```{{exec}}

```bash
kubectl -n session283884 describe pod prestop
```{{exec}}

</details>