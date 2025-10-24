Connect to the `redis-pod` container using the Redis CLI and inspect the configuration values.

Open the Redis shell:
```bash
kubectl exec -it redis-pod -- redis-cli
```{{exec}}

From the Redis prompt, retrieve the `maxmemory` setting:
```bash
CONFIG GET maxmemory
```{{copy}}

In the same session, check the `maxmemory-policy` setting:
```bash
CONFIG GET maxmemory-policy
```{{copy}}
