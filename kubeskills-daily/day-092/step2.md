# Step 2 — Identify the Root Cause

Three services, three empty endpoint lists, three different root causes. Work through each one.

## Diagnose checkout-svc: Label Key-Value Mismatch

Start with the most fundamental question: what does the Service selector say it wants?

```bash
kubectl get service checkout-svc -o jsonpath='{.spec.selector}{"\n"}'
```{{exec}}

Output: `{"app":"checkout"}`

Now check what labels the pods actually have:

```bash
kubectl get pods -l app=checkout-api --show-labels
```{{exec}}

Pods exist with `app=checkout-api`. But the service is selecting `app=checkout` — no `checkout` label exists anywhere.

Confirm nothing matches:

```bash
kubectl get pods -l app=checkout
```{{exec}}

Output: `No resources found`

The application was renamed from `checkout` to `checkout-api` (a common refactor). The Deployment's pod template and selector were updated, but nobody updated the Service selector. The mismatch is one word: `checkout` vs `checkout-api`.

Check the Deployment's own matchLabels to understand the intended labels:

```bash
kubectl get deployment checkout \
  -o jsonpath='{.spec.selector.matchLabels}{"\n"}'
```{{exec}}

Output: `{"app":"checkout-api"}` — the Deployment knows the right label. The Service does not.

### Root Cause 1 — checkout-svc: selector `app=checkout` does not match pods labeled `app=checkout-api`

---

## Diagnose inventory-svc: Populated Endpoints but Wrong Port

This one is more deceptive. The inventory Service selector is correct — let's prove it:

```bash
kubectl get pods -l app=inventory
```{{exec}}

Pods exist. The selector key/value matches. So why are Endpoints still empty?

Get a detailed look:

```bash
kubectl describe endpoints inventory-svc
```{{exec}}

Endpoints are empty. Yet the pods are running. Check the Service's port configuration:

```bash
kubectl get service inventory-svc -o jsonpath='{.spec.ports}{"\n"}'
```{{exec}}

Output: `[{"port":8080,"protocol":"TCP","targetPort":8081}]`

The Service listens on port 8080 and forwards to `targetPort: 8081` on the pod. Now check what port the container is actually listening on:

```bash
kubectl get deployment inventory \
  -o jsonpath='{.spec.template.spec.containers[0].ports}{"\n"}'
```{{exec}}

Output: `[{"containerPort":80,"protocol":"TCP"}]`

The container exposes port 80. The service is trying to forward to port 8081. Even if the selector matches, the Endpoints controller uses `targetPort` when building the endpoint addresses — and `kube-proxy` will try to connect to port 8081 on the pod, which has nothing listening there.

> **Note:** `containerPort` in a pod spec is documentation only — it doesn't open or close ports. What matters is the actual port the process inside the container is bound to, and whether the Service's `targetPort` matches it.

Verify the actual listening port by running a quick check inside a pod:

```bash
kubectl exec -it $(kubectl get pod -l app=inventory -o jsonpath='{.items[0].metadata.name}') \
  -- sh -c 'ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null'
```{{exec}}

Port 80 is listening. Port 8081 is not.

### Root Cause 2 — inventory-svc: `targetPort: 8081` does not match the container's actual listening port 80

---

## Diagnose payments-svc: Multi-Label Selector Partial Match

```bash
kubectl get service payments-svc -o jsonpath='{.spec.selector}{"\n"}'
```{{exec}}

Output: `{"app":"payments","version":"v2"}`

The Service requires **both** `app=payments` AND `version=v2`. A service selector is an AND condition — every key-value pair must match.

Check what the pods actually have:

```bash
kubectl get pods -l app=payments --show-labels
```{{exec}}

The pods have `app=payments` and `version=v1`. One label matches, one doesn't.

Run a precise selector query to prove both conditions together fail:

```bash
kubectl get pods -l 'app=payments,version=v2'
```{{exec}}

Output: `No resources found`

But with just `app=payments`:

```bash
kubectl get pods -l 'app=payments'
```{{exec}}

The pods exist. The first label matches. The second doesn't. Because service selectors require **all** pairs to match, even one mismatch produces empty Endpoints.

```bash
kubectl get pods -l 'version=v2'
```{{exec}}

Output: `No resources found` — no pod in the cluster carries `version=v2`.

### Root Cause 3 — payments-svc: selector requires `version=v2` but pods carry `version=v1`

---

## Summary of Findings

| Service         | Endpoints | Root Cause                                         |
|-----------------|-----------|----------------------------------------------------|
| `checkout-svc`  | Empty     | Selector `app=checkout`; pods labeled `app=checkout-api` |
| `inventory-svc` | Empty     | Selector matches but `targetPort: 8081` ≠ container port 80 |
| `payments-svc`  | Empty     | Selector requires `version=v2`; pods have `version=v1` |
