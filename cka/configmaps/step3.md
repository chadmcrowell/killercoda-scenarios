Get a shell to the `redis-pod` pod and open the redis cli to confirm the values have been applied.

> HINT: Use `redis-cli`{{copy}} to get to the redis cli


<br>
<details><summary>Solution</summary>
<br>

Run the following command to get a shell to the `redis-pod` pod
```bash
k exec -it redis-pod -- sh

```

Run the following command to get the `maxmemory` configuration setting:
```bash
CONFIG GET maxmemory
```{{copy}}

Run the following command to get the `maxmemory-policy` configuration setting:
```bash
CONFIG GET maxmemory-policy
```{{copy}}


</details>