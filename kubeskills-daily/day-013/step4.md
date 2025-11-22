## Step 4: Check why drain is blocked

```bash
kubectl get pdb critical-app-pdb -o yaml
```{{exec}}

```bash
kubectl describe pdb critical-app-pdb
```{{exec}}

`status.disruptionsAllowed` is 0 and the describe output lists protected pods.
