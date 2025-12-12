<br>

### Reconciliation loops tamed

**Key observations**

✅ Status subresource prevents spec resourceVersion churn.  
✅ observedGeneration gates work to once-per-generation.  
✅ Owner references garbage-collect dependents; finalizers delay deletion until cleanup.  
✅ Conditions and phases communicate state; backoff avoids hot loops.  
✅ Idempotent creates/updates stop controllers from reconciling themselves to death.

**Production patterns**

```python
def reconcile(namespace, name, obj):
    spec = obj['spec']
    status = obj.get('status', {})
    gen = obj['metadata']['generation']
    if status.get('observedGeneration') == gen:
        return  # already reconciled
    ensure_configmap(namespace, name, spec)
    update_status(namespace, name, {
        'phase': 'Ready',
        'observedGeneration': gen
    })
```

**Cleanup**

```bash
kubectl delete webapp --all
kubectl delete configmap test-app-config with-conditions-config 2>/dev/null
kubectl delete crd webapps.apps.example.com
kubectl delete clusterrolebinding webapp-operator 2>/dev/null
kubectl delete clusterrole webapp-operator 2>/dev/null
kubectl delete serviceaccount webapp-operator 2>/dev/null
rm -f /tmp/operator.py /tmp/bad-operator.sh /tmp/smart-reconcile.sh
```{{exec}}

---

Next: Day 31 - Helm Chart Templating Errors
