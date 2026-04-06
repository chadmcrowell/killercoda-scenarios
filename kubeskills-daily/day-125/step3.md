## Step 3 — Apply the Fix

Create a RoleBinding in the development namespace that connects the app-runner service account to the new least-privilege Role. Verify that the service account can still perform its required operations within the development namespace but can no longer access resources in other namespaces or perform cluster-level operations.
