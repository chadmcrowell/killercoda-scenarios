## Step 1 — Investigate the Problem

Write an audit policy file that logs metadata for all requests but logs full request details for operations on secrets and configmaps. Ensure deletion events are captured at the RequestResponse level so the full payload is recorded.
