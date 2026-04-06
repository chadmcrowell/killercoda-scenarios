## Step 2 — Identify the Root Cause

Delete the misconfigured ClusterRoleBinding that grants cluster-admin to the app-runner service account. Then create a new Role in the development namespace that grants only the permissions the application actually needs, which are the ability to get and list pods and config maps within that namespace.
