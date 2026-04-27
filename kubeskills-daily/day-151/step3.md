## Step 3 — Apply the Fix

Apply the correct pod annotations or mesh configuration entries to exclude the affected ports from proxy interception, then verify that the startup ordering between the proxy container and the application container is correct so the application does not attempt connections before the proxy is ready.
