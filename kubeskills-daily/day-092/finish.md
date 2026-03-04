# Congratulations

You've completed Day 92: **Service Selector Mismatch Traffic Debugging**.

## What You Learned

- A Kubernetes Service routes traffic through the **Endpoints object** — if no pods match the selector, Endpoints is empty and all traffic is silently dropped with no error event
- `kubectl get endpoints` is the single most important command when a Service isn't routing; populated endpoints = selector is fine; empty endpoints = selector problem
- Service selectors are **AND conditions** — every key-value pair must match; one mismatch among multiple labels produces the same empty Endpoints as a complete mismatch
- `targetPort` in a Service must match the actual port the **process** binds to inside the container — `containerPort` in the pod spec is documentation only and does not open or close ports
- Populated Endpoints with failed connections points to a `targetPort` mismatch — the routing table has pod IPs but the connection is refused because nothing listens on that port
- Named ports (e.g., `name: http` on the container, `targetPort: "http"` on the Service) decouple the Service from the exact port number and reduce misconfiguration risk
- The four-step endpoint debugging runbook: check Endpoints → extract selector → find matching pods → compare targetPort to actual container port

## Why It Matters

Service selector mismatches are a leading cause of mysterious application outages after refactoring, label standardization, or copy-paste errors. In production, this failure is especially dangerous because all components appear healthy: pods are Running, the Service exists, there are no error events — yet user traffic is silently dropped. Always run `kubectl get endpoints` immediately after creating or modifying a Service.

Keep building. See you tomorrow!

— Chad

KubeSkills Daily — Fail Fast, Learn Faster
