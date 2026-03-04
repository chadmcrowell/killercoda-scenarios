# Step 2 — Identify the Root Cause

Two Deployments are stuck Pending. One is running but ignoring its placement preference. The causes are different for each — understand each one.

## Diagnose gpu-worker: Hard Affinity, No Matching Node

Describe one of the Pending `gpu-worker` pods:

```bash
kubectl describe pod -l app=gpu-worker | grep -A15 "Events:"
```{{exec}}

You'll see:

```text
Warning  FailedScheduling  ...
  0/2 nodes are available:
  2 node(s) didn't match Pod's node affinity/selector.
```

The scheduler checked every node and none satisfied the affinity rule. Inspect the exact rule in the Deployment spec:

```bash
kubectl get deployment gpu-worker \
  -o jsonpath='{.spec.template.spec.affinity}{"\n"}' | python3 -m json.tool 2>/dev/null \
  || kubectl get deployment gpu-worker -o jsonpath='{.spec.template.spec.affinity}{"\n"}'
```{{exec}}

The rule is `requiredDuringSchedulingIgnoredDuringExecution` with `key: accelerator, operator: In, values: [nvidia-gpu]`. Now check what labels the nodes actually have:

```bash
kubectl get nodes --show-labels
```{{exec}}

No node has `accelerator=nvidia-gpu`. Confirm directly:

```bash
kubectl get nodes -l accelerator=nvidia-gpu
```{{exec}}

Output: `No resources found`

`requiredDuringSchedulingIgnoredDuringExecution` is a **hard constraint**. The scheduler will never place the pod unless a matching node exists. These pods will stay Pending indefinitely.

### Root Cause — gpu-worker: hard required affinity for `accelerator=nvidia-gpu`; no node carries this label

## Diagnose cache-server: Hard Affinity, Wrong Zone Label

Describe the Pending `cache-server` pod:

```bash
kubectl describe pod -l app=cache-server | grep -A15 "Events:"
```{{exec}}

Same pattern: `0/2 nodes are available: 2 node(s) didn't match Pod's node affinity/selector.`

Check the required label:

```bash
kubectl get deployment cache-server \
  -o jsonpath='{.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0]}{"\n"}'
```{{exec}}

Output: `{"key":"zone","operator":"In","values":["us-east-1a"]}`

The pod requires `zone=us-east-1a`. Check all zone-related labels on nodes:

```bash
kubectl get nodes -L zone,topology.kubernetes.io/zone
```{{exec}}

Neither column has a value. No `zone` label exists on any node.

### Root Cause — cache-server: hard required affinity for `zone=us-east-1a`; no node is labeled with this zone

## Diagnose web-frontend: Soft Affinity, Silent Miss

Now look at `web-frontend`, which IS running. Check which node it landed on:

```bash
kubectl get pod -l app=web-frontend -o wide
```{{exec}}

It's running on `node01` (or `controlplane`). Check whether that node has the `tier=frontend` label:

```bash
kubectl get nodes -l tier=frontend
```{{exec}}

Output: `No resources found`

The pod is running on a node that doesn't match its preference. Inspect the affinity type:

```bash
kubectl get deployment web-frontend \
  -o jsonpath='{.spec.template.spec.affinity.nodeAffinity}{"\n"}'
```{{exec}}

The key is `preferredDuringSchedulingIgnoredDuringExecution`. This is a **soft constraint**: the scheduler will try to place the pod on a matching node, but if none exists it schedules the pod anyway. The pod runs but the preference was silently ignored — no warning, no event, no indication anything is wrong.

### Root Cause — web-frontend: soft preferred affinity for `tier=frontend`; preference silently ignored because no node matches

## The Core Difference

| Affinity Type                                    | Behavior when no node matches        |
|--------------------------------------------------|--------------------------------------|
| `requiredDuringSchedulingIgnoredDuringExecution` | Pod stays **Pending** indefinitely   |
| `preferredDuringSchedulingIgnoredDuringExecution`| Pod schedules **anywhere**, no error |

`IgnoredDuringExecution` on both types means: if the matching label is removed from a node **after** a pod is already running there, the pod keeps running and is not evicted.

## Summary of Findings

| Deployment    | Status  | Affinity Type | Root Cause                            |
|---------------|---------|---------------|---------------------------------------|
| `gpu-worker`  | Pending | required      | No node has `accelerator=nvidia-gpu`  |
| `cache-server`| Pending | required      | No node has `zone=us-east-1a`         |
| `web-frontend`| Running | preferred     | Preference silently ignored           |
