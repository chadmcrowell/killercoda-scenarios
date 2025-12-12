## Step 11: Test values file override

```bash
cat > override.yaml << 'OV'
database:
  password: "from-override-file"
OV

helm template myapp . -f override.yaml | grep password
```{{exec}}

Override file beats default values.yaml.
