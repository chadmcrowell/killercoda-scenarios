## Step 10: Simulate kube-proxy failure

```bash
kubectl scale daemonset kube-proxy -n kube-system --replicas=0 2>&1 || echo "DaemonSet replicas can't be scaled directly"
PROXY_POD=$(kubectl get pods -n kube-system -l k8s-app=kube-proxy -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod -n kube-system $PROXY_POD
sleep 10
```{{exec}}

```bash
kubectl run failtest --rm -it --restart=Never --image=curlimages/curl -- curl -m 5 http://web-service 2>&1 || echo "Service unavailable!"
```{{exec}}

Service traffic may fail while kube-proxy is down.
