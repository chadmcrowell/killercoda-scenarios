Create a ConfigMap named `game-config` from a file, then mount it as a volume in a pod.

<details><summary>Solution</summary>
<br>

```bash
echo "max_players=100" > config.txt
kubectl -n session283884 create configmap game-config --from-file=config.txt
```{{exec}}

```bash
cat <<EOF | kubectl -n session283884 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cm-vol-pod
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
      name: game-config
EOF
```{{exec}}

</details>