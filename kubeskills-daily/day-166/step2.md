## Step 2 — Identify the Root Cause

Identify which pods have no resource requests set making them BestEffort class, then update those pods that are critical to the business by adding appropriate resource requests and limits to elevate them to Burstable or Guaranteed QoS.
