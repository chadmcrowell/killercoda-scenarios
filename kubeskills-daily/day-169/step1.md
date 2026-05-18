## Step 1 — Investigate the Problem

Inspect a pod that is stuck in ImagePullBackOff and examine its events to identify whether the failure is due to a missing secret reference, a secret that does not exist, or a credential that is incorrect. Note the exact error message returned by the kubelet.
