Use an `emptyDir` volume to share data between containers in the same pod.

1. Create a pod named `shared-pod` in namespace `volumes` with two containers (`writer` and `reader`).
2. Mount a shared `emptyDir` volume at `/data` in both containers.
3. Have the writer continually append a timestamp to `/data/out.log`; the reader should tail the file.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace volumes
```{{exec}}

```bash
cat <<'EOF_POD' > shared-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: shared-pod
  namespace: volumes
spec:
  containers:
  - name: writer
    image: busybox:1.36
    command:
      - sh
      - -c
      - |
        while true; do
          date >> /data/out.log
          sleep 2
        done
    volumeMounts:
    - name: shared
      mountPath: /data
  - name: reader
    image: busybox:1.36
    command:
      - sh
      - -c
      - tail -f /data/out.log
    volumeMounts:
    - name: shared
      mountPath: /data
  volumes:
  - name: shared
    emptyDir: {}
EOF_POD
```{{exec}}

```bash
kubectl apply -f shared-pod.yaml
```{{exec}}

```bash
kubectl -n volumes logs shared-pod -c reader --tail=10
```{{exec}}

</details>
