Create a pod with one container that will log to STDOUT

cat << EOF > pod-logging.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-logging
spec:
  containers:
  - name: main
    image: busybox
    args: [/bin/sh, -c, 'while true; do echo $(date); sleep 1; done']
EOF

Use kubectl to view the logs from this container within the pod named "pod-logging"

<br>
<details><summary>Solution</summary>
<br>

```bash
k logs pod-logging
```

</details>