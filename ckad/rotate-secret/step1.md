Create a Secret in the `session283884` namespace named `db-pass` with key `password=oldpass`, mount it in a pod, then update the Secret.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create secret generic db-pass --from-literal=password=oldpass
```{{exec}}

cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secretpod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - name: secret
      mountPath: /etc/secret
  volumes:
  - name: secret
    secret:
      secretName: db-pass
EOF
```{{exec}}

```bash
kubectl -n session283884 create secret generic db-pass --from-literal=password=newpass -o yaml --dry-run=client | kubectl apply -f -
```{{exec}}

</details>