## Step 8: Test log destination failure

```bash
kubectl patch configmap fluent-bit-config -n logging --type=merge -p '
{
  "data": {
    "fluent-bit.conf": "[SERVICE]\n    Flush 5\n\n[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    Parser docker\n    Tag kube.*\n\n[OUTPUT]\n    Name es\n    Match *\n    Host nonexistent-elasticsearch\n    Port 9200\n    Retry_Limit 5\n"
  }
}'

kubectl rollout restart daemonset fluent-bit -n logging
kubectl wait --for=condition=Ready pods -l app=fluent-bit -n logging --timeout=120s
```{{exec}}

```bash
kubectl logs -n logging -l app=fluent-bit --tail=50 | grep -i "connection\|failed\|error"
```{{exec}}

Fluent Bit shows connection failures when the destination is unreachable.
