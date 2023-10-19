Create a pod that will have two containers, one main container and another sidecar container that will collect the main containers logs

Using kubectl, view the logs from the container named "sidecar"

<br>
<details><summary>Solution</summary>
<br>

```bash
cat << EOF > pod-logging-sidecar.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-logging-sidecar
spec:
  containers:
  - image: busybox
    name: main
    args: [ 'sh', '-c', 'while true; do echo "$(date)\n" >> /var/log/main-container.log; sleep 5; done' ]
    volumeMounts:
      - name: varlog
        mountPath: /var/log
  - name: sidecar
    image: busybox
    args: [ /bin/sh, -c, 'tail -f /var/log/main-container.log' ]
    volumeMounts:
      - name: varlog
        mountPath: /var/log
  volumes:
    - name: varlog
      emptyDir: {}
EOF
```{{exec}}

```bash
k logs pod-logging-sidecar -c sidecar

k logs pod-logging-sidecar -all-containers

k logs pod-logging-sidecar -all-containers -f
```{{exec}}

</details>