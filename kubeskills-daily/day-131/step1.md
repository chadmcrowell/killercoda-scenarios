## Step 1 — Investigate the Problem

Run the kubeadm upgrade plan command to see what the upgrade will do and what compatibility warnings it raises. Use kubectl convert or manually review existing manifests to identify any resources using deprecated API versions that will be removed in the target version. Update those manifests to use the current stable API versions and reapply them.
