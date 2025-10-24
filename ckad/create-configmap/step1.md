Create a configmap named `redis-config`. Within the configMap, use the key `maxmemory` with value `2mb` and key `maxmemory-policy` with value `allkeys-lru`.

**HINT:** try `k create cm -h` for command options and examples

<details><summary>Solution</summary>
<br>

```bash
kubectl create configmap redis-config \
  --from-literal=maxmemory=2mb \
  --from-literal=maxmemory-policy=allkeys-lru
```{{exec}}

```bash
kubectl get configmap redis-config -o yaml
```{{exec}}

</details>
