# Day 90 — Multi-Container Pod Sidecar Failure Debugging

The application team escalated an urgent issue: their `web-app` pod keeps restarting every few minutes. They insist the main container code is fine — but the restarts won't stop and traffic is being disrupted.

A closer look reveals this is a multi-container pod. The main `app` container is healthy. The `log-forwarder` sidecar is crashing on every start, and because all containers in a pod share the same lifecycle, it's taking the entire pod down with it.

In this scenario you will:

- Deploy a multi-container pod with a crashing sidecar and observe the restart loop in real time
- Use per-container log and status commands to isolate which container is failing and why
- Fix the volume mount path mismatch that causes the sidecar to crash on startup
- Walk through creating a correctly configured multi-container pod from scratch

Click **Start** to begin.
