Create a pod in the `session283884` namespace named `startup-probe-pod` using image `nginx` and define a startup probe on path `/` that runs only during startup.

<details><summary>Solution</summary>
<br>

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: startup-probe-pod
spec:
  containers:
  - name: nginx
    image: nginx
    startupProbe:
      httpGet:
        path: /
        port: 80
      failureThreshold: 10
      periodSeconds: 5
EOF
```{{exec}}

</details>