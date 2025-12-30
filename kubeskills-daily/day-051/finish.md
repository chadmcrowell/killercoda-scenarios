<br>

### API server overload lessons

**Key observations**

- APF queues/priorities control throughput; rejected requests show as 429.
- System/prioritized flows should protect controllers from user floods.
- Watches and lists are expensive; many watches consume inflight slots.
- Webhook latency/timeout affects API responsiveness; failurePolicy matters.
- Custom FlowSchemas/PriorityLevels tune fairness per user/workload.
- Client-side rate limiting and timeouts help avoid overload.

**Production patterns**

```bash
kubectl get --raw /metrics | grep apiserver_request_duration_seconds
kubectl get --raw /metrics | grep 'apiserver_request_total.*code="5'
```

```yaml
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: PriorityLevelConfiguration
metadata:
  name: cicd-priority
spec:
  type: Limited
  limited:
    nominalConcurrencyShares: 30
    limitResponse:
      type: Queue
      queuing:
        queues: 64
        queueLengthLimit: 50
        handSize: 4
```

```yaml
apiVersion: flowcontrol.apiserver.k8s.io/v1beta3
kind: FlowSchema
metadata:
  name: cicd-flows
spec:
  matchingPrecedence: 500
  priorityLevelConfiguration:
    name: cicd-priority
  rules:
  - subjects:
    - kind: ServiceAccount
      serviceAccount:
        name: cicd-bot
        namespace: cicd
    resourceRules:
    - apiGroups: ["*"]
      resources: ["*"]
      verbs: ["*"]
```

**Cleanup**

```bash
kubectl delete flowschema test-flow
kubectl delete prioritylevelconfiguration test-priority
kubectl delete validatingwebhookconfiguration load-test-webhook
kubectl delete serviceaccount load-test-sa
kubectl delete pod webhook-test-{1..10} 2>/dev/null
rm -f /tmp/api-load.sh
```{{exec}}

---

Next: Day 52 - etcd Corruption and Quorum Loss
