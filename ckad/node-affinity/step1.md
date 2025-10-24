In the namespace named `012963bd`, create a pod named `az1-pod` which uses the `busybox:1.28` image. This pod should use node affinity, and prefer during scheduling to be placed on the node with the label `availability-zone=zone1` with a weight of 80.

Also, have that same pod prefer to be scheduled to a node with the label `availability-zone=zone2` with a weight of 20.

> NOTE: Make sure the container remains in a running state

Ensure that the pod is scheduled to the `controlplane` node.

<details><summary>Solution</summary>
<br>

```bash
kubectl create namespace 012963bd
```{{exec}}

```bash
kubectl label node controlplane availability-zone=zone1 --overwrite
kubectl label node node01 availability-zone=zone2 --overwrite
```{{exec}}

```bash
cat <<'EOF_MANIFEST' > az1-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: az1-pod
  namespace: 012963bd
spec:
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 80
        preference:
          matchExpressions:
          - key: availability-zone
            operator: In
            values:
            - zone1
      - weight: 20
        preference:
          matchExpressions:
          - key: availability-zone
            operator: In
            values:
            - zone2
  containers:
  - name: main
    image: busybox:1.28
    command: ["sh", "-c", "sleep 3600"]
  restartPolicy: Never
EOF_MANIFEST
```{{exec}}

```bash
kubectl apply -f az1-pod.yaml
```{{exec}}

```bash
kubectl -n 012963bd get pod az1-pod -o wide
```{{exec}}

</details>
