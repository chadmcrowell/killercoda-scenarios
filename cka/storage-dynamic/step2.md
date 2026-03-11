Now promote `local-path-retain` as the new default StorageClass and remove the default annotation from `local-path`.

- Remove the default annotation from `local-path`
- Set `local-path-retain` as the new default StorageClass

> **Hint:** The annotation that controls the default is:
> `storageclass.kubernetes.io/is-default-class: "true"`

<br>
<details><summary>Solution</summary>
<br>

```bash
# Remove the default annotation from local-path
kubectl patch storageclass local-path -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "false"}}}'
```{{exec}}

```bash
# Set local-path-retain as the new default
kubectl patch storageclass local-path-retain -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
```{{exec}}

Verify the change:

```bash
kubectl get sc
```{{exec}}

`local-path-retain` should show `(default)` and `local-path` should not.

</details>
