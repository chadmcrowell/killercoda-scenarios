# Network Policy Egress - Implementing Default Deny to Close Security Gaps

Your security team has completed a network audit and found that application pods in the payments namespace have unrestricted outbound network access. They can reach external IP addresses, arbitrary internal services, and even call out to the public internet. You need to implement a default-deny egress policy and add specific exceptions for the DNS queries and upstream payment gateway that the application legitimately needs.

> **Day 179 of KubeSkills Daily** — Fail Fast, Learn Faster
