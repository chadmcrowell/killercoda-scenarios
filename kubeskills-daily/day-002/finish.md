<br>

### Nice work!

**Key observations**

✅ `OrderedReady` enforces strict sequencing; a missing ordinal stalls higher pods.
✅ `Parallel` launches every replica immediately—perfect when order does not matter.
✅ Force deletions can wedge StatefulSets because the controller insists on healthy predecessors.

**Production tip**

Use `OrderedReady` for stateful systems (Postgres, ZooKeeper, etc.) and switch to `Parallel` for stateless workloads that only need stable identities.

**Cleanup**

```bash
kubectl delete statefulset web
```{{exec}}

---

Next: Day 3 - OOM Killer vs Resource Limits
