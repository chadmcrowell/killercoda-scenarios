## Step 3 — Apply the Fix

Delete the overly permissive ClusterRoleBinding, create a new namespace-scoped Role with only the required permissions, and bind it to the service account using a RoleBinding in the correct namespace.
