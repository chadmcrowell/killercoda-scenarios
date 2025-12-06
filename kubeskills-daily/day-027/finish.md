<br>

### API throttling understood

**Key observations**

✅ API Priority and Fairness (APF) queues/weights requests by FlowSchemas and PriorityLevels.  
✅ Users/ServiceAccounts get separate quotas; system flows are prioritized.  
✅ Watches are typically exempt; list/get/create are subject to rate limits.  
✅ 429 Too Many Requests signals throttling; metrics show queue and rejection counts.  
✅ Custom FlowSchemas let you tune priority for specific identities and verbs.

**Production patterns**

Prioritize CI/CD traffic:

```yaml
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: PriorityLevelConfiguration
metadata:
  name: ci-cd-priority
spec:
  type: Limited
  limited:
    nominalConcurrencyShares: 50
    limitResponse:
      type: Queue
      queuing:
        queues: 64
        queueLengthLimit: 50
        handSize: 8
---
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: FlowSchema
metadata:
  name: ci-cd-flows
spec:
  matchingPrecedence: 500
  priorityLevelConfiguration:
    name: ci-cd-priority
  rules:
  - subjects:
    - kind: ServiceAccount
      serviceAccount:
        name: ci-cd-bot
        namespace: ci-cd
    resourceRules:
    - apiGroups: ["*"]
      resources: ["*"]
      verbs: ["*"]
```

Monitor throttling:

```bash
apiserver_flowcontrol_rejected_requests_total > 100
```

Backoff in clients:

```bash
max_retries=5
retry=0
while [ $retry -lt $max_retries ]; do
  if kubectl get pods > /dev/null 2>&1; then
    break
  fi
  retry=$((retry + 1))
  sleep $((2 ** retry))
done
```

**Cleanup**

```bash
kubectl delete configmap $(kubectl get cm -o name | grep flood-) 2>/dev/null
kubectl delete flowschema custom-priority 2>/dev/null
kubectl delete serviceaccount api-user 2>/dev/null
rm -f /tmp/api-flood.sh
```{{exec}}

---

Next: Day 28 - Pod Security Admission
