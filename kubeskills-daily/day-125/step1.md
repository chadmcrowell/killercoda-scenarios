## Step 1 — Investigate the Problem

Begin by listing all ClusterRoleBindings in the cluster and look for any that reference the app-runner service account. Then use the auth can-i subcommand with impersonation to verify that the service account can perform sensitive operations like deleting secrets in namespaces it should not have access to.
