# Network Policy Debugging - Restoring Blocked Traffic

Welcome to the Network Policy Debugging lab. Your application was working perfectly until the security team applied deny-all network policies to all namespaces as part of a hardening initiative. Now the web tier cannot reach the API tier, the API tier cannot reach the database, and health checks are failing. The security posture is correct in principle but the allow rules were never added. Your job is to restore connectivity without removing the deny-all baseline.

> **Day 116 of KubeSkills Daily** — Fail Fast, Learn Faster
