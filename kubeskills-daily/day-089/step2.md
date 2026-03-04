# Identify the Root Cause

Lab: Node Affinity Scheduling Failures
URL: https://killercoda.com/chadmcrowell/course/kubeskills-daily/day-089

Intro: Welcome to the Node Affinity debugging lab. A deployment has been configured with node affinity rules that reference node labels which either do not exist or are misspelled. Your job is to understand the scheduling failure, correct the affinity configuration, and verify that pods reach a Running state on appropriate nodes.

Step 1: Inspect the current state of all pods in the affected namespace and identify which pods are stuck in Pending. Then examine the node affinity rules defined in the deployment specification to understand what labels are being required.
Step 2: List all nodes in the cluster and examine their labels carefully. Compare the labels that actually exist on your nodes against what the affinity rules are requesting, and identify the mismatch causing the scheduling failure.
Step 3: Either update the deployment to use the correct label selectors that match existing node labels, or add the missing labels to the appropriate nodes, then confirm that the scheduler successfully places the pods.

Verification: Confirm that all pods in the deployment are in Running state and are scheduled on nodes that match the intended affinity criteria. Check that no pods remain in Pending and that the node affinity rules in the final deployment spec are consistent with the labels on the target nodes.

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```