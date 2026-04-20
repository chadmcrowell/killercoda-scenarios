## Step 1 — Investigate the Problem

List all RoleBindings and ClusterRoleBindings in the cluster and look for any that reference the default service account or that reference roles containing wildcard verbs or resources. Pay special attention to bindings that grant cluster-admin or edit permissions.
