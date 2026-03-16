## Step 3 — Apply the Fix

Add the correct toleration to the deployment pod spec so it matches the node taint, trigger a rollout, and confirm that new pods are now being scheduled and running on the previously idle node.
