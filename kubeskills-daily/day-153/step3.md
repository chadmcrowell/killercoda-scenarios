## Step 3 — Apply the Fix

Delete the overly broad ClusterRoleBinding and create a new Role scoped to the staging namespace that grants only the minimum permissions needed to manage Deployments. Create a corresponding RoleBinding that attaches this new Role to the app-deployer ServiceAccount, then verify the ServiceAccount can still manage deployments but can no longer access secrets or resources in other namespaces.
