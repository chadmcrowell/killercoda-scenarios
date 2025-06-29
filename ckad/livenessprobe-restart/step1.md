Create a pod named `nginx-live` in the `session283884` namespace using image `nginx`, and add a liveness probe that checks path `/` on port 80.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-live
spec:
  containers:
  - name: nginx
    image: nginx
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
```{{exec}}

```bash
kubectl -n session283884 get pod nginx-live
```{{exec}}

</details>