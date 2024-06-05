Run the `kubeadm upgrade plan`{{exec}} command again, and proceed with upgrading the control plane components to 1.30.1

<br>
<details><summary>Solution</summary>
<br>

```plain
# run upgrade plan again
kubeadm upgrade plan
```{{exec}}

```plain
# upgrade components to version v1.27.0
kubeadm upgrade apply v1.30.1
```{{exec}}

</details>
