## Step 2: Taint a node with `NoExecute`

Grab a node name and taint it:

```bash
NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
echo "Tainting node: $NODE"
```{{exec}}

```bash
kubectl taint nodes $NODE dedicated=gpu:NoExecute
```{{exec}}

**Watch pods evacuate:**

```bash
kubectl get pods -o wide -w
```{{exec}}

Pods on the tainted node terminate immediately and reschedule elsewhere.
