## Step 2 — Identify the Root Cause

Edit the audit policy file to add rules that capture reads and writes on secrets at the RequestResponse level, exec and port-forward operations at the Request level, and all authentication failures. Ensure the ordering of rules is correct because the first matching rule wins.
