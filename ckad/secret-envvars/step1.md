Create a Secret named `db-secret` with a username and password and use it as env vars in a pod.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=secret123
```{{exec}}

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: db-env-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["env"]
    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: username
    - name: DB_PASS
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
EOF
```{{exec}}

</details>