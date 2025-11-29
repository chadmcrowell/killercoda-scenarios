<br>

### Tokens tamed

**Key observations**

✅ `automountServiceAccountToken` can be disabled on SA or pod; pod wins on conflict.  
✅ Projected tokens have expiration, audience, and rotate automatically.  
✅ Legacy long-lived secrets are deprecated—prefer token requests or projections.  
✅ Bound token projected volumes are the modern default for pods.  
✅ Short-lived tokens fail after expiration—always scope and rotate credentials.

**Production patterns**

Disable for non-API pods:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: webapp-sa
automountServiceAccountToken: false
```

Operator with projected token:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: operator
spec:
  serviceAccountName: operator-sa
  containers:
  - name: operator
    image: operator:latest
    volumeMounts:
    - name: token
      mountPath: /var/run/secrets/kubernetes.io/serviceaccount
  volumes:
  - name: token
    projected:
      sources:
      - serviceAccountToken:
          path: token
          expirationSeconds: 7200
      - configMap:
          name: kube-root-ca.crt
          items:
          - key: ca.crt
            path: ca.crt
      - downwardAPI:
          items:
          - path: namespace
            fieldRef:
              fieldPath: metadata.namespace
```

External service with audience:

```yaml
volumes:
- name: vault-token
  projected:
    sources:
    - serviceAccountToken:
        path: token
        audience: vault.example.com
        expirationSeconds: 3600
```

**Cleanup**

```bash
kubectl delete pod default-token no-token-pod sa-no-token override-mount projected-token rotating-token multi-audience bound-token api-caller 2>/dev/null
kubectl delete sa no-auto-sa token-requester 2>/dev/null
```{{exec}}

---

Next: Day 20 - Node NotReady and Pod Eviction
