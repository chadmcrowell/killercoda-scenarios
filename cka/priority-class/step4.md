You may have apps that must always stay running, such as:
- Logging/monitoring agents
- Control-plane components (in self-managed clusters)
- Payment gateways
- Message queues

Assigning them higher priority ensures they get scheduled first, and they don't get evicted before the lower priority pods.

Create a pod that uses the `high-priority` priority class created in a previous step. Name the pod `high-prio` and use the `polinxu/stress` image with the command `["--cpu", "1", "--vm", "1", "--vm-bytes", "512M", "--timeout", "300s"]`.  

<br>
<details><summary>Solution</summary>
<br>

```yaml
# high-prio.yaml
apiVersion: v1
kind: Pod
metadata:
  name: high-prio
spec:
  priorityClassName: high-priority
  containers:
  - name: stress
    image: polinux/stress
    command: ["stress"]
    args: ["--cpu", "1", "--vm", "1", "--vm-bytes", "512M", "--timeout", "300s"]
    resources:
      requests:
        memory: "600Mi"
        cpu: "200m"
```{{copy}}

```bash
# create the pod
kubectl create -f high-prio.yaml
```{{exec}}

</details>