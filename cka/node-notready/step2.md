You've identified the kubelet as the root cause. SSH to `node01` to investigate and fix it:

```bash
ssh node01
```{{exec}}

Check the kubelet service status:

```bash
sudo systemctl status kubelet
```{{exec}}

Read the kubelet logs to practice diagnosing from systemd:

```bash
sudo journalctl -u kubelet --no-pager | tail -30
```{{exec}}

Restart the kubelet:

```bash
sudo systemctl start kubelet
```{{exec}}

Exit back to the control plane:

```bash
exit
```{{exec}}

Watch `node01` return to `Ready`:

```bash
kubectl get nodes -w
```{{exec}}

Press `Ctrl+C` once both nodes show `Ready`, then confirm all pods reschedule:

```bash
kubectl get pods -n trouble-node-01 -o wide
```{{exec}}

All 5 `api` pods should now be `Running`.

<br>
<details><summary>Solution</summary>
<br>

```bash
ssh node01
sudo systemctl start kubelet
exit
kubectl get nodes
kubectl get pods -n trouble-node-01 -o wide
```{{exec}}

</details>

**Mental checklist for node scheduling failures:**

1. `kubectl get nodes` — is the node `Ready`?
2. `kubectl describe node <name>` — check Conditions and Events for root cause
3. SSH to the node → `sudo systemctl status kubelet`
4. Read kubelet logs: `sudo journalctl -u kubelet`
5. Check scheduling events: `kubectl get events -n <namespace>`
