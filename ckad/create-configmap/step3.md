Get a shell to the `redis-pod` pod and open the redis-cli.

Run the following command to get the `maxmemory` configuration setting:
```
CONFIG GET maxmemory
```{{copy}}

Run the following command to get the `maxmemory-policy` configuration setting:
```
CONFIG GET maxmemory-policy
```{{copy}}