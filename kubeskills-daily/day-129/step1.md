## Step 1 — Investigate the Problem

Examine the first pod which is stuck in Init status. Look at the pod description to identify which init container is blocking and what it is waiting for. Investigate why the dependency the init container is checking for does not exist and determine whether you need to create the missing resource or fix the init container command.
