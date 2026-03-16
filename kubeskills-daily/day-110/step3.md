## Step 3 — Apply the Fix

Add explicit resource requests to the deployment pod spec so the scheduler and autoscaler correctly account for the pod resource needs, then observe the autoscaler logs to confirm it now triggers a scale-up event and wait for new nodes to join the cluster.
