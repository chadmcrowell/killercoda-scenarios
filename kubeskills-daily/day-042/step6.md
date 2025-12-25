## Step 6: Fix with regex parser

```bash
kubectl patch configmap fluent-bit-config -n logging --type=merge -p '
{
  "data": {
    "parsers.conf": "[PARSER]\n    Name   docker\n    Format json\n    Time_Key time\n    Time_Format %Y-%m-%dT%H:%M:%S.%L\n    Time_Keep On\n\n[PARSER]\n    Name   plain\n    Format regex\n    Regex  ^(?<log>.*)$\n"
  }
}'

kubectl rollout restart daemonset fluent-bit -n logging
```{{exec}}

Adds a plain regex parser to handle non-JSON logs and restarts Fluent Bit.
