Create a pod named `tcp-check` using image `nginx` with a TCP liveness probe on port 80.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: tcp-check
spec:
  containers:
  - name: nginx
    image: nginx
    livenessProbe:
      tcpSocket:
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
EOF
```{{exec}}

</details>