A team reports that their application Pod is stuck in `Pending` state. The following resources have already been created in the `dev` namespace.

Start by gathering information about the broken resources:

```bash
kubectl get pvc broken-pvc -n dev
```{{exec}}

```bash
kubectl get pv
```{{exec}}

```bash
kubectl describe pod broken-app -n dev
```{{exec}}

Use `describe` to dig deeper into why the PVC cannot bind:

```bash
kubectl describe pvc broken-pvc -n dev
```{{exec}}

```bash
kubectl describe pv broken-pv
```{{exec}}

> **What are you looking for?** Compare the `Access Modes` and `Capacity` between the PV and the PVC. A PVC can only bind to a PV when the access modes and storage request are compatible.
