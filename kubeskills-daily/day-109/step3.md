## Step 3 — Apply the Fix

Create or update the image pull secret with valid credentials, ensure it is referenced correctly in the deployment pod spec under imagePullSecrets, and trigger a new rollout to confirm pods can now pull the image and reach Running state.
