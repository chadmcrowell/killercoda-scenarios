## Step 3 — Apply the Fix

Delete the failing pod so it is recreated by its deployment controller and verify that it pulls the image successfully. Then simulate what happens when a secret is present in one namespace but a pod in a different namespace tries to reference it.
