<br>

### Finalizers defeated

**Key observations**

✅ Finalizers block deletion even with deletionTimestamp set until they are cleared.  
✅ Built-in protection finalizers (PVC/PV, namespaces) prevent accidental loss.  
✅ Multiple finalizers all must be removed; force removal is an emergency-only option.  
✅ Stuck resources can be found by checking deletionTimestamp and finalizer lists.  
✅ Controllers should clean up external state before removing their finalizers.

**Production patterns**

Custom controller with finalizer:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: managed-resource
  finalizers:
  - myoperator.example.com/cleanup
data:
  externalResource: "db-instance-123"
```

Controller cleanup pseudocode:

```go
if resource.DeletionTimestamp != nil {
    deleteExternalDB(resource.Data["externalResource"])
    removeFinalizer(resource, "myoperator.example.com/cleanup")
    update(resource)
}
```

PVC protection (automatic):

```yaml
metadata:
  finalizers:
  - kubernetes.io/pvc-protection
```

**Cleanup**

```bash
kubectl delete namespace finalizer-test stuck-namespace cleanup-test 2>/dev/null
kubectl delete pod pvc-user 2>/dev/null
kubectl delete pvc test-pvc 2>/dev/null
kubectl delete configmap test-cm multi-finalizer 2>/dev/null
```{{exec}}

---

🎉 Week 3 Complete! 21 days of Kubernetes failure modes conquered.
