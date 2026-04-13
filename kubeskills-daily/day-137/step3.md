## Step 3 — Apply the Fix

Update the deployment with the correct readiness probe path and port that matches an endpoint the application actually serves. Observe as the probe begins succeeding, pods are added back to the Endpoints object, and service traffic is restored.
