## Step 3 — Apply the Fix

Drain the worker node to safely evict all running pods before upgrading it. SSH to the worker node and upgrade the kubeadm, kubelet, and kubectl binaries to the target version. Run kubeadm upgrade node on the worker and restart kubelet. Return to the control plane and uncordon the worker node so it can accept new pod scheduling.
