- Run the command to list the services

Use this command to run busybox pod and get a shell to it for troubleshooting:
```
kubectl run -it --rm --restart=Never busybox --image=gcr.io/google-containers/busybox sh
```{{exec}}

- From the `busybox` pod, see if the service is responding via its DNS name

- From the `busybox` pod, see if the service is responding via its FQDN

[View the kubernetes.io documentation for more info on the service FQDN](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#services)

- Check that your /etc/resolv.conf file in your Pod is correct

- Check if the `kubernetes` service is responding via DNS from inside the `busybox` pod

- Test whether your Service works by its IP address

<br>
<details><summary>Solution</summary>
<br>

```plain
# list the services
kubectl get svc
```{{exec}}

```plain
# from 'busybox' pod, contact service via DNS
nslookup hostnames
```{{copy}}

```plain
# from 'busybox' pod, contact service via FQDN
nslookup hostnames.default.svc.cluster.local
```{{copy}}

```plain
# from 'busybox' pod, check /etc/resolv.conf
cat /etc/resolv.conf
```{{copy}}

```plain
# from 'busybox' pod, contact 'kubernetes' service
nslookup kubernetes.default
```{{copy}}

```plain
# from 'busybox' pod, check the IP of the service
for i in $(seq 1 3); do 
    wget -qO- 10.0.1.175:80
done
```{{copy}}

</details>