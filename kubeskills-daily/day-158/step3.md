## Step 3 — Apply the Fix

Create a DaemonSet that runs on every node and pre-pulls the application image using an init container, then exits cleanly. Apply this pre-puller before triggering a deployment rollout and verify that all nodes complete the image pull during the DaemonSet phase rather than during pod scheduling, resulting in near-instant container startup across all nodes.
