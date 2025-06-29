Create a pod named `nginx-ready` in the `session283884` namespace using image `nginx`, and configure an HTTP readiness probe on port 80 with path `/`.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-ready
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
```{{exec}}

```bash
kubectl -n session283884 get pod nginx-ready
```{{exec}}

</details>