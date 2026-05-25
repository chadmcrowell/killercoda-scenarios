## Step 1 — Investigate the Problem

Describe each of the failing pods and examine the Events section to see the specific image pull error message. For each pod, determine whether the pull secret referenced in the pod spec or service account actually exists in the same namespace as the pod, and check whether the secret contains valid credentials by decoding its data field.
