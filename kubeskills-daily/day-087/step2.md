# Step 2 — Identify the Root Cause

Two DaemonSets, two different failure modes. Investigate each one separately.

## Diagnose node-exporter: DESIRED=0

When a DaemonSet shows DESIRED=0, the controller found no nodes eligible to run the pod. The most common cause is a `nodeSelector` or `nodeAffinity` that matches nothing.

Inspect the DaemonSet's nodeSelector:

```bash
kubectl get daemonset node-exporter \
  -o jsonpath='{.spec.template.spec.nodeSelector}{"\n"}'
```{{exec}}

Output: `{"node-monitoring":"enabled"}`

The DaemonSet will only schedule on nodes that carry the label `node-monitoring=enabled`. Check what labels the nodes actually have:

```bash
kubectl get nodes --show-labels
```{{exec}}

No node has a `node-monitoring` label. Confirm with a direct label query:

```bash
kubectl get nodes -l node-monitoring=enabled
```{{exec}}

Output: `No resources found`

Zero matching nodes → DESIRED=0 → zero pods created. The DaemonSet is sitting idle, collecting nothing, with no error visible unless you inspect the spec.

### Root Cause — node-exporter: `nodeSelector: {node-monitoring: "enabled"}` matches no nodes

## Diagnose log-collector: DESIRED=2, READY=0

The `log-collector` has no `nodeSelector`, so it targets all 2 nodes. But both pods are Pending. Describe the pods to see the scheduling error:

```bash
kubectl describe pod -l app=log-collector
```{{exec}}

In the **Events** section at the bottom of the output, look for:

```text
Warning  FailedScheduling  ...  0/2 nodes are available:
  1 node(s) had untolerated taint {dedicated: logging},
  1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }.
```

Both nodes have taints the pod can't tolerate. Inspect the taints on each node directly:

```bash
kubectl describe node controlplane | grep -A5 Taints
```{{exec}}

```bash
kubectl describe node node01 | grep -A5 Taints
```{{exec}}

- `controlplane`: taint `node-role.kubernetes.io/control-plane:NoSchedule`
- `node01`: taint `dedicated=logging:NoSchedule`

Now check what tolerations the `log-collector` pods have:

```bash
kubectl get daemonset log-collector \
  -o jsonpath='{.spec.template.spec.tolerations}{"\n"}'
```{{exec}}

Output: `null`

No tolerations at all. Every node in this cluster has at least one `NoSchedule` taint, so every pod the DaemonSet creates is immediately unschedulable.

### Root Cause — log-collector: no tolerations; neither node's taint is tolerated

## Summary of Findings

| DaemonSet       | Symptom                  | Root Cause                                           |
|-----------------|--------------------------|------------------------------------------------------|
| `node-exporter` | DESIRED=0, no pods       | `nodeSelector` requires a label no node has          |
| `log-collector` | DESIRED=2, READY=0       | No tolerations for either node's `NoSchedule` taint  |
