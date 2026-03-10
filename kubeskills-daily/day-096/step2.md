# Step 2 — Identify the Root Cause

The node conditions pointed to `NodeStatusUnknown`. Now SSH into the worker node and read the kubelet logs to confirm the certificate authentication failure, then inspect the certificate files directly.

## Read the Kubelet Logs on node01

Click the **node01** tab. Check the kubelet service status first:

```bash
sudo systemctl status kubelet
```{{exec}}

```text
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled)
     Active: active (running) since ...
   Main PID: 1842 (kubelet)
...
```

The service shows as `active (running)` — the kubelet process is alive. The problem is not a crash. Pull the last 50 log lines to find the error:

```bash
sudo journalctl -u kubelet -n 50 --no-pager
```{{exec}}

Look for lines containing `certificate` or `tls` or `x509`:

```text
...
E0310 09:12:04.312451    1842 reflector.go:147] k8s.io/client-go/informers/factory.go:150: Failed to watch *v1.Node: failed to list *v1.Node: Get "https://172.30.1.2:6443/api/v1/nodes?...": tls: failed to verify certificate: x509: certificate signed by unknown authority
E0310 09:12:04.318213    1842 controller.go:144] Failed to ensure lease exists, will retry in 7s, error: Get "https://172.30.1.2:6443/apis/coordination.k8s.io/v1/...": tls: failed to verify certificate: x509: certificate signed by unknown authority
E0310 09:12:04.512891    1842 kubelet.go:2479] Unable to authenticate to API server: x509: certificate signed by unknown authority
```

The kubelet is running but every request to the API server fails with `x509: certificate signed by unknown authority`. The kubelet is trying to use a client certificate that the API server cannot validate.

## Inspect the Certificate Files

List the kubelet PKI directory:

```bash
sudo ls -la /var/lib/kubelet/pki/
```{{exec}}

```text
total 24
drwxr-x--- 2 root root 4096 Mar 10 09:00 .
drwxr-x--- 8 root root 4096 Mar 10 09:00 ..
-rw------- 1 root root 2286 Mar 10 09:00 kubelet-client-2024-01-15-09-00-00.pem
lrwxrwxrwx 1 root root   59 Mar 10 09:00 kubelet-client-current.pem -> kubelet-client-2024-01-15-09-00-00.pem
-rw-r--r-- 1 root root 2175 Mar 10 09:00 kubelet.crt
-rw------- 1 root root 1679 Mar 10 09:00 kubelet.key
```

`kubelet-client-current.pem` is a symlink to the actual timestamped cert file. Check whether the current cert has any content:

```bash
sudo wc -c /var/lib/kubelet/pki/kubelet-client-current.pem
```{{exec}}

```text
0 /var/lib/kubelet/pki/kubelet-client-current.pem
```

The file is 0 bytes — it is empty. This is the simulated failure. In a real expiration scenario, the file exists and has content but the dates are in the past. Inspect the backup to see what a valid cert looks like:

```bash
sudo openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem.bak \
  -noout -subject -issuer -dates
```{{exec}}

```text
subject=O = system:nodes, CN = system:node:node01
issuer=CN = kubernetes
notBefore=Jan 15 09:00:00 2024 GMT
notAfter=Jan 15 09:00:00 2025 GMT
```

Key fields:

- `subject=O=system:nodes, CN=system:node:node01` — this is the kubelet's identity. The `system:nodes` group and `system:node:<name>` CN are required for the Node authorizer to grant the kubelet permission to manage its own node object.
- `issuer=CN=kubernetes` — signed by the cluster CA.
- `notAfter` — in a real expiration scenario, this date is in the past.

## Inspect the Kubelet Kubeconfig

Check what kubeconfig the kubelet uses to connect to the API server:

```bash
sudo cat /etc/kubernetes/kubelet.conf | grep client-certificate
```{{exec}}

```text
    client-certificate: /var/lib/kubelet/pki/kubelet-client-current.pem
    client-key: /var/lib/kubelet/pki/kubelet-client-current.pem
```

The kubelet kubeconfig points to the same cert that is now empty. Every API call the kubelet makes uses this kubeconfig — heartbeats, pod status updates, volume mounts, log streaming — all failing.

## Root Cause Summary

| Component | Expected | Actual | Result |
| --- | --- | --- | --- |
| `kubelet-client-current.pem` | Valid cert signed by cluster CA | Empty (0 bytes) | All API server calls fail with `x509` error |
| Kubelet process | Running and communicating | Running but blocked | Node heartbeats stop, node transitions to `NotReady` |
| API server | Receives node heartbeats | Receives nothing | Node marked `NodeStatusUnknown`, pods stay `Pending` |

**Root cause:** The kubelet client certificate used to authenticate to the API server is invalid. Without a valid cert, the kubelet cannot send heartbeats, update pod status, or receive scheduling instructions. The node's containers continue running but are invisible to the control plane.
