## Step 3 — Apply the Fix

Fix the label mismatch by patching the Deployment pod template to use the correct label key and value that matches the Service selector. Wait for the rollout to complete and then verify that the endpoint slice is populated with the pod IPs before confirming that traffic now routes successfully.
