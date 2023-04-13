Create a pod named `az1-pod`{{copy}} which uses the `busybox:1.28`{{copy}} image. This pod should use node affinity, and prefer during scheduling to be placed on the node with the label `availability-zone=zone1`{{copy}} with a weight of 80.

Also, have that same pod prefer to be scheduled to a node with the label `availability-zone=zone2`{{copy}} with a weight of 20.

> NOTE: Make sure the container remains in a running state

Ensure that the pod is scheduled to the `controlplane` node.