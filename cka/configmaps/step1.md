Create a configmap named `redis-config`. Within the configMap, use the key `maxmemory` with value `2mb` and key `maxmemory-policy` with value `allkeys-lru`.

**HINT:** try `k create cm -h` for command options and examples

<br>
<details><summary>Solution</summary>
<br>

```bash
k create configmap redis-config --from-literal=key1=config1 --from-literal=key2=config2 --dry-run=client -o yaml > redis-config.yaml
```{{exec}}

```bash
cat << EOF > redis-configMap.yaml
apiVersion: v1
data:
  redis-config: |
    maxmemory: 2mb
    maxmemory-policy: allkeys-lru
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: redis-config
EOF
```{{exec}}

</details>