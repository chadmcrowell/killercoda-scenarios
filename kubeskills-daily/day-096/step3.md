# Step 3 — Apply the Fix

Two approaches restore the kubelet's ability to communicate with the API server. Option A restores the backup certificate — this is valid when the cert is not actually expired and the corruption was accidental. Option B re-bootstraps the kubelet entirely by generating a new bootstrap token and letting the kubelet request a fresh certificate — this is the correct path when the cert has genuinely expired and cannot be recovered.

## Option A — Restore the Valid Certificate

Click the **node01** tab. Copy the backup cert back into place:

```bash
sudo cp /var/lib/kubelet/pki/kubelet-client-current.pem.bak \
        /var/lib/kubelet/pki/kubelet-client-current.pem
```{{exec}}

Restart the kubelet to pick up the restored certificate:

```bash
sudo systemctl restart kubelet
```{{exec}}

Switch to the **controlplane** tab and watch the node recover:

```bash
kubectl get nodes -w
```{{exec}}

```text
NAME           STATUS     ROLES           AGE   VERSION
controlplane   Ready      control-plane   25m   v1.29.0
node01         NotReady   <none>          23m   v1.29.0
node01         Ready      <none>          23m   v1.29.0
```

Press `Ctrl+C` once `node01` returns to `Ready`. Skip to **Final Verification** below.

---

## Option B — Re-Bootstrap with a New Certificate

Use this path when the certificate has truly expired and the backup is also expired or unavailable. The kubelet supports re-bootstrapping: you delete its kubeconfig, provide a bootstrap token, and the kubelet requests a brand-new certificate via a CertificateSigningRequest.

### Generate a New Bootstrap Token on the Control Plane

On the **controlplane** tab, create a short-lived bootstrap token:

```bash
kubeadm token create --print-join-command
```{{exec}}

```text
kubeadm join 172.30.1.2:6443 --token abc123.xyz789abc123xyz7 \
    --discovery-token-ca-cert-hash sha256:a1b2c3d4e5f6...
```

Note the token value (e.g. `abc123.xyz789abc123xyz7`) — you will need it in the next step.

Get the API server address:

```bash
kubectl cluster-info | grep 'Kubernetes control plane'
```{{exec}}

```text
Kubernetes control plane is running at https://172.30.1.2:6443
```

### Create the Bootstrap Kubeconfig on node01

Click the **node01** tab. Create a bootstrap kubeconfig using the token from the previous step. Replace `<TOKEN>` with your token value:

```bash
sudo kubeadm kubeconfig user \
  --client-name system:bootstrap:<TOKEN_ID> \
  --org system:bootstrappers > /tmp/bootstrap-kubeconfig.conf
```{{exec}}

Alternatively, write the bootstrap kubeconfig manually:

```bash
sudo bash -c 'cat > /etc/kubernetes/bootstrap-kubelet.conf <<EOF
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/pki/ca.crt
    server: https://172.30.1.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubelet-bootstrap
  name: bootstrap
current-context: bootstrap
users:
- name: kubelet-bootstrap
  user:
    token: <PASTE_FULL_TOKEN_HERE>
EOF'
```{{exec}}

Remove the stale kubelet kubeconfig and the invalid cert so the kubelet is forced to bootstrap fresh:

```bash
sudo mv /etc/kubernetes/kubelet.conf /etc/kubernetes/kubelet.conf.bak
```{{exec}}

```bash
sudo rm /var/lib/kubelet/pki/kubelet-client-current.pem
```{{exec}}

Restart the kubelet:

```bash
sudo systemctl restart kubelet
```{{exec}}

### Approve the CertificateSigningRequest

Switch to the **controlplane** tab. The kubelet immediately submits a CSR to the API server requesting a new client certificate. List pending CSRs:

```bash
kubectl get csr
```{{exec}}

```text
NAME        AGE   SIGNERNAME                                    REQUESTOR                  REQUESTEDDURATION   CONDITION
csr-xk2p9   5s    kubernetes.io/kube-apiserver-client-kubelet   system:bootstrap:abc123    <none>              Pending
```

Approve the CSR:

```bash
kubectl certificate approve csr-xk2p9
```{{exec}}

```text
certificatesigningrequest.certificates.k8s.io/csr-xk2p9 approved
```

Once approved, the API server signs a new certificate and the kubelet writes it to `/var/lib/kubelet/pki/`. Watch the node come back:

```bash
kubectl get nodes -w
```{{exec}}

Press `Ctrl+C` when `node01` returns to `Ready`.

---

## Final Verification

Confirm both nodes are healthy:

```bash
kubectl get nodes
```{{exec}}

```text
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   30m   v1.29.0
node01         Ready    <none>          28m   v1.29.0
```

Confirm the pending pods from Step 1 are now scheduled:

```bash
kubectl get pods -n node-test -o wide
```{{exec}}

```text
NAME                   READY   STATUS    RESTARTS   AGE   NODE
web-5f9b7c6d4-4xkpq    1/1     Running   0          8m    node01
web-5f9b7c6d4-7tnrm    1/1     Running   0          8m    controlplane
web-5f9b7c6d4-9lbzv    1/1     Running   0          8m    node01
web-5f9b7c6d4-vwq2j    1/1     Running   0          8m    controlplane
```

The previously-`Pending` pods have been scheduled onto `node01` now that the scheduler sees it as `Ready`.

Verify the kubelet on `node01` is posting heartbeats by checking the node's `LastHeartbeatTime`:

```bash
kubectl describe node node01 | grep -A5 'Conditions:'
```{{exec}}

```text
Conditions:
  Type                 Status  LastHeartbeatTime   LastTransitionTime  Reason                       Message
  ----                 ------  -----------------   ------------------  ------                       -------
  MemoryPressure       False   ...                 ...                 KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   ...                 ...                 KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   ...                 ...                 KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    ...                 ...                 KubeletReady                 kubelet is posting node status
```

`Ready: True` with `KubeletReady` confirms the kubelet has re-established authenticated communication with the API server.

---

## NotReady Node Debugging Runbook

When a node shows `NotReady`:

```bash
# 1. Check node conditions and last heartbeat
kubectl describe node <node-name> | grep -A 10 'Conditions:'

# 2. Check node-level events
kubectl get events --field-selector involvedObject.name=<node-name> --all-namespaces

# 3. SSH to the node and check kubelet logs
journalctl -u kubelet -n 100 --no-pager | grep -i 'error\|x509\|cert\|tls'

# 4. Verify the kubelet client cert is valid and not expired
sudo openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem \
  -noout -subject -dates 2>/dev/null || echo "CERT INVALID OR EMPTY"

# 5. Check kubelet service status
sudo systemctl status kubelet
```

If the cert is expired or missing, the fix is one of:

- **Restore a valid backup** and restart kubelet
- **Re-bootstrap** using a new token, delete kubelet.conf, restart kubelet, approve the CSR
- **Check auto-rotation** — ensure `rotateCertificates: true` is set in `/var/lib/kubelet/config.yaml` to prevent recurrence
