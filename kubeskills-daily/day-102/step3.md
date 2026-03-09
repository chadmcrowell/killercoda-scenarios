## Step 3 — Apply the Fix

Increase the termination grace period to give the application enough time to complete the preStop hook and then finish draining any in-flight requests. Perform another rolling update while generating traffic and verify that no connection errors occur this time.
