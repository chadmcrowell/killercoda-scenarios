# Step 3 — Apply the Fix

Fix each service and verify that real traffic flows after every change.

## Fix 1 — checkout-svc: Correct the Selector

The Service selector uses the old name `checkout`. Patch it to match the pods' actual label `checkout-api`:

```bash
kubectl patch service checkout-svc \
  --type=json \
  -p='[{"op":"replace","path":"/spec/selector/app","value":"checkout-api"}]'
```{{exec}}

The Endpoints controller reacts immediately. Verify Endpoints are now populated:

```bash
kubectl get endpoints checkout-svc
```{{exec}}

You should see pod IP addresses listed. Confirm with a live traffic test:

```bash
kubectl run test --image=busybox:1.35 --rm -it --restart=Never -- \
  wget -qO- http://checkout-svc
```{{exec}}

You should receive nginx's default HTML page. Traffic is flowing.

---

## Fix 2 — inventory-svc: Correct the targetPort

The Service forwards to port 8081 but nginx listens on port 80. Fix the `targetPort`:

```bash
kubectl patch service inventory-svc \
  --type=json \
  -p='[{"op":"replace","path":"/spec/ports/0/targetPort","value":80}]'
```{{exec}}

Verify Endpoints are now populated:

```bash
kubectl get endpoints inventory-svc
```{{exec}}

Test traffic on the service port (8080 → pod port 80):

```bash
kubectl run test --image=busybox:1.35 --rm -it --restart=Never -- \
  wget -qO- http://inventory-svc:8080
```{{exec}}

nginx responds. The fix confirmed.

> **Note on targetPort:** `targetPort` can be a number (e.g., `80`) or a named port (e.g., `"http"`). Named ports are defined in the container spec as `name: http` and let you change the port number without updating the Service — a safer pattern for production.

---

## Fix 3 — payments-svc: Remove the Version Constraint

The current pods are `version=v1`. The correct fix depends on intent:

- If `v2` pods should exist but don't → the deployment is missing; fix the deployment
- If the `version=v2` constraint was a mistake → fix the service

Here the constraint was a copy-paste error. Remove it from the selector:

```bash
kubectl patch service payments-svc \
  --type=json \
  -p='[{"op":"remove","path":"/spec/selector/version"}]'
```{{exec}}

Confirm the selector is now just `app: payments`:

```bash
kubectl get service payments-svc -o jsonpath='{.spec.selector}{"\n"}'
```{{exec}}

Verify Endpoints:

```bash
kubectl get endpoints payments-svc
```{{exec}}

Test traffic:

```bash
kubectl run test --image=busybox:1.35 --rm -it --restart=Never -- \
  wget -qO- http://payments-svc
```{{exec}}

---

## Final Verification

Check all three Endpoints at once:

```bash
kubectl get endpoints
```{{exec}}

All three should show real pod IP addresses — no more `<none>`.

Run one final all-services test from a single pod:

```bash
kubectl run final-test --image=busybox:1.35 --rm -it --restart=Never -- \
  sh -c '
    echo "=== checkout-svc ===" && wget -qO- http://checkout-svc | head -3
    echo "=== inventory-svc ===" && wget -qO- http://inventory-svc:8080 | head -3
    echo "=== payments-svc ===" && wget -qO- http://payments-svc | head -3
  '
```{{exec}}

All three services return responses.

---

## Endpoint Debugging Runbook

When a Service is not routing traffic, run these four commands in order:

```bash
# 1. Is the Service's Endpoints list populated?
kubectl get endpoints <service-name>

# 2. What selector is the Service using?
kubectl get service <service-name> -o jsonpath='{.spec.selector}{"\n"}'

# 3. Do any pods match ALL of those labels?
kubectl get pods -l 'key1=val1,key2=val2' --show-labels

# 4. If endpoints exist but traffic fails — check the targetPort
kubectl get service <service-name> -o jsonpath='{.spec.ports}{"\n"}'
kubectl get deployment <name> -o jsonpath='{.spec.template.spec.containers[0].ports}{"\n"}'
```{{exec}}

Empty Endpoints → selector problem. Populated Endpoints → port problem. This four-step sequence resolves the vast majority of Kubernetes service routing failures.
