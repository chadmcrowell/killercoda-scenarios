## Step 13: Test log enrichment

```bash
kubectl patch configmap fluent-bit-config -n logging --type=merge -p '
{
  "data": {
    "fluent-bit.conf": "[SERVICE]\n    Flush 5\n\n[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    Parser docker\n    Tag kube.*\n\n[FILTER]\n    Name kubernetes\n    Match kube.*\n    Kube_URL https://kubernetes.default.svc:443\n    Merge_Log On\n    K8S-Logging.Parser On\n    K8S-Logging.Exclude On\n\n[OUTPUT]\n    Name stdout\n    Match *\n    Format json_lines\n"
  }
}'

kubectl rollout restart daemonset fluent-bit -n logging
```{{exec}}

```bash
kubectl logs -n logging -l app=fluent-bit --tail=20
```{{exec}}

Logs now include pod, namespace, and labels from Kubernetes metadata.
