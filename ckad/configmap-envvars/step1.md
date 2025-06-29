Create a ConfigMap named `env-config` with `ENV=production` and use it as environment variables in a pod.

<details><summary>Solution</summary>
<br>

```bash
kubectl -n session283884 create configmap env-config --from-literal=ENV=production
```{{exec}}

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cm-env-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["env"]
    envFrom:
    - configMapRef:
        name: env-config
EOF
```{{exec}}

</details>