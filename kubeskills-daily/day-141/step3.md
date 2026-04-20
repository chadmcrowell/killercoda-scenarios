## Step 3 — Apply the Fix

Create new Roles with only the specific verbs and resource names required by each application. Update the RoleBindings to reference the new minimal Roles and delete the old overly permissive bindings. Confirm the application pods still function correctly.
