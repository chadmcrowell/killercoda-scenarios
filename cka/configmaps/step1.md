Create a configmap named `redis-config`. Within the configMap, use the key `maxmemory` with value `2mb` and key `maxmemory-policy` with value `allkeys-lru`.

**HINT:** try `k create cm -h` for command options and examples

<br>
<details><summary>Solution</summary>
<br>

Quickly create a YAML file for the `configMap`
```bash
k create configmap redis-config --from-literal=redis.conf=config --dry-run=client -o yaml > redis-config.yaml
```{{exec}}

Open the file `redis-config.yaml` and insert the mutli-line values for redis.conf
```yaml
apiVersion: v1
data:
  redis.conf: |
    maxmemory 2mb
    maxmemory-policy allkeys-lru
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: redis-config
```{{copy}}

Create the `configMap` from the file `redis-config.yaml`
```bash
k apply -f redis-config.yaml
```

</details>