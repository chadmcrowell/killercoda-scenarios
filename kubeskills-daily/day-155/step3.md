## Step 3 — Apply the Fix

Modify the resource declarations on the monitoring pod to set both requests and limits to identical values, changing its QoS class to Guaranteed. Redeploy the pod and simulate memory pressure again by observing the eviction order to confirm that Guaranteed pods are the last to be evicted compared to Burstable and BestEffort pods.
