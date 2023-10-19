Get a shell to the `redis-pod` pod and open the redis-cli.


<br>
<details><summary>Solution</summary>
<br>

Run the following command to get the `maxmemory` configuration setting:
```bash
CONFIG GET maxmemory
```{{copy}}

Run the following command to get the `maxmemory-policy` configuration setting:
```bash
CONFIG GET maxmemory-policy
```{{copy}}


</details>