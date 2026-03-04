# Step 2 — Identify the Root Cause

You know the pod is crashing. Now use per-container commands to isolate which container is at fault and exactly why it's failing.

## Check Logs Per Container

With multi-container pods you must specify which container's logs you want with `-c <container-name>`. Without it, kubectl picks the first container.

Check the `app` container logs — is nginx healthy?

```bash
kubectl logs -l app=web-app -c app
```{{exec}}

nginx logs look normal. The main application is working fine.

Now check the `log-forwarder` sidecar logs:

```bash
kubectl logs -l app=web-app -c log-forwarder
```{{exec}}

You'll see:

```text
Starting log forwarder...
tail: can't open '/var/log/app/access.log': No such file or directory
```

The sidecar exits immediately because the file it's trying to tail doesn't exist. Exit code 1 → container crash → pod restart.

To see the logs from the **previous** crash (before the current restart), use `--previous`:

```bash
kubectl logs -l app=web-app -c log-forwarder --previous
```{{exec}}

Same error. This confirms it's not a transient issue — the sidecar crashes every single time it starts.

## Describe the Pod for Full Container State

```bash
kubectl describe pod -l app=web-app
```{{exec}}

In the **Containers** section, look at each container's **Last State**:

```text
Containers:
  app:
    State:          Running
    Ready:          True
    Restart Count:  0

  log-forwarder:
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Error
      Exit Code:    1
    Ready:          False
    Restart Count:  4
```

`app` has 0 restarts. `log-forwarder` is in `CrashLoopBackOff` with an exit code of 1 and a climbing restart count.

## Find the Two Root Causes

**Root Cause 1 — Wrong path:**

The sidecar tails `/var/log/app/access.log`. Nginx writes its access log to `/var/log/nginx/access.log`. The path is wrong.

**Root Cause 2 — Missing volume mount:**

The shared `emptyDir` volume `shared-logs` is mounted into the `app` container at `/var/log/nginx`. But the `log-forwarder` container has no `volumeMount` at all — it can't see the nginx log directory even if the path were corrected.

Confirm by inspecting the volume mounts in the pod spec:

```bash
kubectl get pod -l app=web-app \
  -o jsonpath='{range .items[0].spec.containers[*]}Container: {.name}{"\n"}VolumeMounts: {.volumeMounts}{"\n\n"}{end}'
```{{exec}}

`app` shows a volumeMount for `shared-logs` at `/var/log/nginx`. `log-forwarder` shows no volumeMounts.

**Root Cause 3 — No resource limits on the sidecar:**

```bash
kubectl get pod -l app=web-app \
  -o jsonpath='{range .items[0].spec.containers[*]}Container: {.name}, Resources: {.resources}{"\n"}{end}'
```{{exec}}

Neither container has resource limits. A runaway sidecar (log agent processing a spike) could consume all node memory and starve the main application. This should be fixed while we're here.

## Summary of Findings

| Issue | Detail |
|-------|--------|
| Wrong path | Sidecar tails `/var/log/app/access.log`; nginx writes to `/var/log/nginx/access.log` |
| Missing volumeMount | `shared-logs` volume not mounted into the sidecar container |
| No resource limits | Sidecar has no CPU/memory limits; risks starving the main container |
