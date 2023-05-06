Run the appropriate command to check the 

Create a configmap named `redis-config`. Within the configMap, use the key `maxmemory` with value `2mb` and key `maxmemory-policy` with value `allkeys-lru`.

**HINT:** try `k create cm -h` for command options and examples