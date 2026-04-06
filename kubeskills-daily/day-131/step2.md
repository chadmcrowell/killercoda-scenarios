## Step 2 — Identify the Root Cause

Upgrade the kubeadm binary to the target version on the control plane node. Run the kubeadm upgrade apply command for the target version and wait for it to complete. Then upgrade kubectl and kubelet on the control plane node and restart the kubelet service. Verify the control plane components are running at the new version.
