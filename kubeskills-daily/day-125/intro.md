# RBAC Misconfiguration - Fixing Permission Escalation

Welcome to today's lab on RBAC misconfiguration. You have been handed a cluster where a service account called app-runner in the development namespace has been accidentally granted cluster-admin access via a ClusterRoleBinding. Your mission is to find the problem, understand its blast radius, remove the dangerous binding, and create a properly scoped RoleBinding that gives the service account only the permissions it actually needs.

> **Day 125 of KubeSkills Daily** — Fail Fast, Learn Faster
