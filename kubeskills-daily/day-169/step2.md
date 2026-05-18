## Step 2 — Identify the Root Cause

Create a correctly formatted registry credential secret in the appropriate namespace and attach it to the pod specification. Also attach the same secret to the default service account in the namespace so future pods inherit it automatically.
