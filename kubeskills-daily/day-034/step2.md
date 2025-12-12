## Step 2: Set ResourceQuotas per namespace

```bash
cat <<'RQ' | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: team-a
spec:
  hard:
    requests.cpu: "2"
    requests.memory: "4Gi"
    limits.cpu: "4"
    limits.memory: "8Gi"
    pods: "10"
    services: "5"
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: team-b
spec:
  hard:
    requests.cpu: "1"
    requests.memory: "2Gi"
    limits.cpu: "2"
    limits.memory: "4Gi"
    pods: "5"
    services: "3"
RQ
```{{exec}}

Quotas limit resource usage per namespace.
