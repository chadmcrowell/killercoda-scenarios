## Step 3 — Apply the Fix

For the pod with the expired credential, update the existing secret with fresh credentials by replacing its data field with the new base64-encoded docker config JSON. After all three fixes are applied, delete and recreate the affected pods so they retry the image pull with the corrected credentials.
