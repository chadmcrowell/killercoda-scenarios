## Step 3 — Apply the Fix

For the pod stuck on a hanging preStop hook, review the hook configuration and check what the terminationGracePeriodSeconds is set to. Either wait for the grace period to expire or patch the pod's grace period to accelerate cleanup. Once all three pods are gone, verify that the namespace cleanup and StatefulSet update can proceed.
