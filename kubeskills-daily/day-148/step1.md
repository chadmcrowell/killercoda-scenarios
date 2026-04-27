## Step 1 — Investigate the Problem

Examine the current deployments and note which ones use the latest tag, then check the image pull policy setting on each and reason about how Kubernetes will decide whether to pull a new image when a pod restarts on a node that already has a cached copy.
