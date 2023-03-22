- Run the command to list the pods and their labels

- Run the command to list the pods by their label

- Run a command to get the pod IP addresses

- Run the command to view which port the pods are exposed on.

Use this command to run busybox pod and get a shell to it for troubleshooting:
```
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
```{{exec}}

- From a shell to a pod, see if the pods are listening on the correct port.

You should get the following output:
```bash
hostnames-632524106-bbpiw
hostnames-632524106-ly40y
hostnames-632524106-tlaok
```

<br>
<details><summary>Solution</summary>
<br>

```plain
# get the pod labels
kubectl get po --show-labels
```{{exec}}

```plain
# list the pods by their label
kubectl get pods -l app=hostnames
```{{exec}}

```plain
# get the pod IPs
kubectl get po -o wide
```{{exec}}

```plain
# from inside the 'busybox' pod, see if the pods are responding on port 9376
for ep in 10.244.0.5:9376 10.244.0.6:9376 10.244.0.7:9376; do
    wget -qO- $ep
done
```{{copy}}

</details>
