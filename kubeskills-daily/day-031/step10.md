## Step 10: Test value precedence

```bash
cat >> values.yaml << 'EOFVAL'
database:
  password: "from-values-file"
EOFVAL

helm template myapp . --set database.password="from-flag" | grep password
```{{exec}}

`--set` overrides the value from `values.yaml`.
