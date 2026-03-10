# Step 1 — Investigate the Problem

Simulate the cert expiration on the worker node, then trace the failure from the control plane perspective down to the node and affected workloads.

## Break the Kubelet Client Certificate

Click the **node01** tab and run the following commands to simulate a kubelet certificate expiration. You will back up the current certificate and create an empty placeholder that the kubelet cannot use to authenticate:

```bash
sudo cp /var/lib/kubelet/pki/kubelet-client-current.pem \
        /var/lib/kubelet/pki/kubelet-client-current.pem.bak
```{{exec}}

```bash
sudo truncate -s 0 /var/lib/kubelet/pki/kubelet-client-current.pem
```{{exec}}

Restart the kubelet so it attempts to use the corrupted certificate:

```bash
sudo systemctl restart kubelet
```{{exec}}

## Observe the Node Status from the Control Plane

Switch back to the **controlplane** tab. Wait a few seconds for the node condition to propagate, then check node status:

```bash
kubectl get nodes
```{{exec}}

```text
NAME           STATUS     ROLES           AGE   VERSION
controlplane   Ready      control-plane   20m   v1.29.0
node01         NotReady   <none>          18m   v1.29.0
```

`node01` has transitioned to `NotReady`. Unlike a crashed VM, the node itself is still running — its containers are still alive — but the API server has lost authenticated communication with the kubelet on that node.

## Describe the Affected Node

Get the full condition detail from the control plane:

```bash
kubectl describe node node01
```{{exec}}

Look for the `Conditions` section:

```text
Conditions:
  Type                 Status    LastHeartbeatTime   LastTransitionTime  Reason                       Message
  ----                 ------    -----------------   ------------------  ------                       -------
  MemoryPressure       Unknown   ...                 ...                 NodeStatusUnknown            Kubelet stopped posting node status.
  DiskPressure         Unknown   ...                 ...                 NodeStatusUnknown            Kubelet stopped posting node status.
  PIDPressure          Unknown   ...                 ...                 NodeStatusUnknown            Kubelet stopped posting node status.
  Ready                False     ...                 ...                 KubeletNotReady              container runtime network not ready: NetworkPlugin cni0...
```

All conditions have transitioned to `Unknown` with the reason `NodeStatusUnknown`. The control plane stopped receiving heartbeats from the kubelet — this is the signature of a broken node-to-API-server connection, which can be caused by network issues, kubelet crashes, or authentication failures.

## Check What Happens to Workloads

Deploy a test workload to see how the scheduler and API server respond to a NotReady node:

```bash
kubectl create namespace node-test
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: node-test
spec:
  replicas: 4
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:stable
EOF
```{{exec}}

Check where the pods land:

```bash
kubectl get pods -n node-test -o wide
```{{exec}}

```text
NAME                   READY   STATUS    RESTARTS   AGE   NODE
web-5f9b7c6d4-4xkpq    0/1     Pending   0          8s    <none>
web-5f9b7c6d4-7tnrm    1/1     Running   0          8s    controlplane
web-5f9b7c6d4-9lbzv    0/1     Pending   0          8s    <none>
web-5f9b7c6d4-vwq2j    1/1     Running   0          8s    controlplane
```

Some pods land on `controlplane` and the rest are `Pending` — the scheduler is avoiding `node01` entirely because it is `NotReady`. Pods will not be scheduled onto a node the control plane cannot communicate with.

Check the events for the node to confirm:

```bash
kubectl get events --field-selector involvedObject.name=node01 --all-namespaces
```{{exec}}

```text
LAST SEEN   TYPE      REASON                    OBJECT      MESSAGE
...
10s         Warning   NodeNotReady              Node/node01 Node node01 status is now: NodeNotReady
```

The next step is to find out exactly why the kubelet lost its connection to the API server.
