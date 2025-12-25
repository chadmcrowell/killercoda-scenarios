## Step 11: Configure multiline parser

```bash
kubectl patch configmap fluent-bit-config -n logging --type=merge -p '
{
  "data": {
    "parsers.conf": "[PARSER]\n    Name   docker\n    Format json\n\n[PARSER]\n    Name   multiline\n    Format regex\n    Regex  /^(?<log>Exception.*)$/\n"
  }
}'
```{{exec}}

Add a regex-based multiline parser for exceptions.
