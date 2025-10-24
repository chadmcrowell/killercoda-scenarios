Create a Secret in the `session283884` namespace named `app-secret` with key `password=pass123`, and mount it as a volume in a pod.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create secret generic app-secret --from-literal=password=pass123
```{{exec}}

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-vol
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - name: secrets
      mountPath: /etc/secrets
  volumes:
  - name: secrets
    secret:
      secretName: app-secret
EOF
```{{exec}}

</details>