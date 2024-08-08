Create a Network Policy and limit acess to the pods behind the service. ONLY allow communication from pods with the label `access=true` to pods that match the `app=nginx` label (includes the pods within that deployment we just created). 

> NOTE: You can check the labels of existing pods with the command `k get po --show-labels`{{copy}}

Test this Network Policy by running a temporary pod, getting a shell to it with this command:
```bash
kubectl run busybox --rm -ti --image=busybox:1.28 -- /bin/sh
```{{copy}}

From a shell to the container within this temporary pod, try connecting to the nginx pods using this command:
```bash
wget --spider --timeout=1 nginx
```{{copy}}

You should not be able to communicate with the nginx pods, because the temporary pod doesn't have the correct label applied to it.

<br>
<details><summary>Solution</summary>
<br>

```bash
cat << EOF > netpol.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: access-nginx
spec:
  podSelector:
    matchLabels:
      app: nginx
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: "true"
EOF
```{{exec}}

```bash
k create -f netpol.yaml
```{{exec}}


</details>