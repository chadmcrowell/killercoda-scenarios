Create a ConfigMap named `app-config` with a key `version=1.0`. Mount it in a pod. Then update the value to `2.0`.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create configmap app-config --from-literal=version=1.0
```{{exec}}

cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: configpod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - name: config
      mountPath: /etc/config
  volumes:
  - name: config
    configMap:
      name: app-config
EOF
```{{exec}}

```bash
kubectl -n session283884 create configmap app-config --from-literal=version=2.0 -o yaml --dry-run=client | kubectl apply -f -
```{{exec}}

</details>