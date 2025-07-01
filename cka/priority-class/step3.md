If no priority class is set in the pod spec, the pod gets a priority value of `0` by default. This means, it's the first to be eviced if the node is under memory or CPU pressure.

Create a deployment named `low-prio` that has `3` pod replicas. Use the `polinux/stress` image with the command `["stress]` and the argument `["--vm", "1", "--vm-bytes", "400M", "--timeout", "600s"]`. The pod should request `500` Mebibytes of memory and `100` millicores of CPU.

> 📝 EXAM TIP: Use the `--dry-run` flag to create the deployment and output to a file, or use the [Kubernetes documentation](https://kubernetes.io/docs) for help.

<br>
<details><summary>Solution</summary>
<br>

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: low-prio
spec:
  replicas: 3
  selector:
    matchLabels:
      app: low-prio
  template:
    metadata:
      labels:
        app: low-prio
    spec:
      containers:
      - name: stress
        image: polinux/stress
        command: ["stress"]
        args: ["--vm", "1", "--vm-bytes", "400M", "--timeout", "600s"]
        resources:
          requests:
            memory: "500Mi"
            cpu: "100m"
EOF
```{{exec}}

Ensure all three pod replicas are up and running before proceeding
```bash
# view pod status
kubectl get po
```{{exec}}

</details>