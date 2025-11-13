Check if your cluster already runs a CNI that supports Network Policies:

```bash
kubectl get pods -n kube-system | grep -E "calico|cilium|weave"
```{{exec}}

If nothing shows up (the usual Killercoda default), install Calico:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
```{{exec}}

Wait ~30 seconds for the Calico pods to become Ready.

## Step 1: Deploy two communicating pods

```bash
# Pod 1: Web server
kubectl run web --image=nginx --labels="app=web" --port=80

# Pod 2: Client
kubectl run client --image=busybox --command -- sleep 3600
```{{exec}}

**Test connectivity:**

```bash
kubectl exec client -- wget -qO- --timeout=2 http://web
```{{exec}}

You should see the nginx welcome HTML.
