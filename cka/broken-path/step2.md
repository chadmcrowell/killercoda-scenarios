You've confirmed that nginx listens on port `80`, but the Service has `targetPort: 8081`. Patch the Service to send traffic to the correct port:

```bash
kubectl patch service web-svc -n trouble-net-01 -p '{"spec": {"ports": [{"port": 80, "targetPort": 80}]}}'
```{{exec}}

Also correct the `containerPort` on the Deployment to reflect the actual port nginx uses (this is informational but keeps your manifests accurate):

```bash
kubectl patch deployment web -n trouble-net-01 --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/ports/0/containerPort", "value": 80}]'
```{{exec}}

Now re-test from a client pod:

```bash
kubectl run tester -n trouble-net-01 --image=busybox --restart=Never --rm -it -- wget -qO- http://web-svc --timeout=5
```{{exec}}

You should see the nginx welcome HTML. Confirm the endpoints still look correct:

```bash
kubectl get endpoints web-svc -n trouble-net-01
```{{exec}}

<br>
<details><summary>Solution</summary>
<br>

```bash
kubectl patch service web-svc -n trouble-net-01 -p '{"spec": {"ports": [{"port": 80, "targetPort": 80}]}}'
kubectl run tester -n trouble-net-01 --image=busybox --restart=Never --rm -it -- wget -qO- http://web-svc --timeout=5
```{{exec}}

</details>

**Mental checklist for Service connectivity failures:**

1. `kubectl get pods` — are pods actually `Running`?
2. `kubectl logs` / `kubectl exec ... curl localhost:<port>` — is the app healthy inside the container?
3. `kubectl get endpoints <svc>` — does the selector match any pods?
4. `kubectl get svc -o yaml` — does `targetPort` match the port the app listens on?
5. Fix the mismatch and re-test from a client pod.
