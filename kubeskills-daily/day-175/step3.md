## Step 3 — Apply the Fix

Restart the API server or update the static pod manifest to reload the corrected audit policy file. Perform a few test operations such as reading a secret and running an exec command, then inspect the audit log to confirm those events now appear with the expected detail level.
