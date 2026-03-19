A Deployment and Service have been created in `trouble-net-01`. Start by confirming the surface-level state looks healthy:

```bash
kubectl get deploy,svc,pods -n trouble-net-01 -o wide
```{{exec}}

Pods are `Running` and the Service exists. Now try to reach the Service from a test pod:

```bash
kubectl run tester -n trouble-net-01 --image=busybox --restart=Never --rm -it -- wget -qO- http://web-svc --timeout=5
```{{exec}}

The request hangs or fails. Before assuming the app is broken, verify nginx itself is healthy inside the pod:

```bash
kubectl logs -n trouble-net-01 -l app=web
```{{exec}}

```bash
kubectl exec -n trouble-net-01 -it $(kubectl get pod -n trouble-net-01 -l app=web -o jsonpath='{.items[0].metadata.name}') -- curl -s localhost:80
```{{exec}}

Nginx responds on port `80` — the application is fine. The problem is in the wiring. Inspect the Service:

```bash
kubectl get svc web-svc -n trouble-net-01 -o yaml
```{{exec}}

Note the `targetPort` value. Now check the Deployment to see what port the container declares:

```bash
kubectl get deploy web -n trouble-net-01 -o yaml
```{{exec}}

Finally, confirm endpoints exist (meaning the selector is matching pods correctly):

```bash
kubectl get endpoints web-svc -n trouble-net-01
```{{exec}}

Endpoints are populated — so labels and selectors are fine. The failure is purely a port mismatch: the Service's `targetPort` is pointing to a port that nginx never listens on.

> **Key insight:** When endpoints exist but the Service is still unreachable, the selector is not the problem. Check that `targetPort` in the Service matches the port the container process actually binds to — not just what `containerPort` declares.
