## Step 3 — Apply the Fix

Examine the third pod where the main application is running but responding slowly. Review the resource limits set on each container and compare the CPU usage of the sidecar proxy against its limit. Adjust the resource allocation between the sidecar and main container so that the main application has sufficient CPU budget to respond normally.
