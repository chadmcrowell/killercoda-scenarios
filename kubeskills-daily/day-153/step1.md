## Step 1 — Investigate the Problem

Inspect the existing ClusterRoleBindings in the cluster and identify which one grants the app-deployer ServiceAccount in the staging namespace elevated permissions. Use the auth can-i command to test what actions the ServiceAccount can perform, including listing secrets and deleting pods in namespaces it should have no access to.
