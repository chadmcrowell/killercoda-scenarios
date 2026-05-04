## Step 1 — Investigate the Problem

Inspect the node conditions on the worker node and identify the MemoryPressure condition. Then look at the node events to find the kubelet eviction messages, noting which pods were evicted first. Check the QoS class assigned to each evicted pod and correlate that with the eviction ordering you observe.
