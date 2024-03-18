In the currect directory, you will see a file named `pod-tolerate.yaml`. Open the file and add a toleration for the taint that's applied to the control plane node.

<br>
<details><summary>Solution</summary>
<br>

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
  nodeSelector:
    kubernetes.io/hostname: controlplane
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"

```{{copy}}


</details>