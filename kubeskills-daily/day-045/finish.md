<br>

### kubectl debug lessons

**Key observations**

- Ephemeral containers attach to running pods and share process namespace with a target.
- `--target` keeps the target container running while you debug alongside it.
- `--copy-to` creates a copy with a debug image to bypass entrypoint issues.
- Node debugging launches a privileged container on the node (chroot to /host).
- Ephemeral containers persist until pod deletion; they cannot be removed individually.
- Profiles set default security contexts for common debug scenarios.

**Production patterns**

```bash
kubectl debug <pod> -it --image=busybox --target=<container> -- sh
```

```bash
kubectl debug <pod> -it --image=nicolaka/netshoot --target=<container>
```

```bash
kubectl debug <pod> -it --copy-to=<pod>-debug --container=<container> --image=busybox -- sh
```

```bash
kubectl debug node/<node-name> -it --image=ubuntu
```

```bash
kubectl debug <pod> -it --profile=restricted --image=busybox --target=<container>
```

**Cleanup**

```bash
kubectl delete pod minimal-app crashloop
kubectl delete pod minimal-app-debug minimal-debug-2 crashloop-debug 2>/dev/null || true
```{{exec}}

---

Next: Day 46 - Readiness vs Liveness Probe Tuning
