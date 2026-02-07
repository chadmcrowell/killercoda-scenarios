## Key Observations

✅ **privileged: true** - grants full host access
✅ **hostPath volumes** - expose host filesystem
✅ **Docker socket** - equivalent to root on host
✅ **Capabilities** - CAP_SYS_ADMIN enables escapes
✅ **Host namespaces** - break container isolation
✅ **Running as root** - weakens security boundary

## Cleanup

```bash
kubectl delete pod restricted-pod privileged-pod hostpath-pod docker-socket-pod cap-sys-admin-pod hostpid-pod hostnetwork-pod root-user-pod proc-reader kernel-access-pod no-seccomp-pod no-apparmor-pod 2>/dev/null
rm -f /tmp/*.sh /tmp/*.md
```{{exec}}

---

**Congratulations!** You've completed 78 days of Kubernetes failure scenarios!
