## Step 12: Test log filtering

```bash
kubectl patch configmap fluent-bit-config -n logging --type=merge -p '
{
  "data": {
    "fluent-bit.conf": "[SERVICE]\n    Flush 5\n\n[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    Parser docker\n    Tag kube.*\n\n[FILTER]\n    Name grep\n    Match kube.*\n    Exclude log DEBUG\n\n[OUTPUT]\n    Name stdout\n    Match *\n"
  }
}'

kubectl rollout restart daemonset fluent-bit -n logging
```{{exec}}

Drops logs containing DEBUG before outputting to stdout.
