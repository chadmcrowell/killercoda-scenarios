Run the command to list the taints applied to node01.

**HINT:** Use the kubectl command to describe the node

<br>
<details><summary>Solution</summary>
<br>

```plain
# list the Taints applied to node01
k describe no node01 | grep Taints
```{{exec}}

The output should look similar to the following:
```bash
Taints:             dedicated=special-user:NoSchedule
```


</details>
