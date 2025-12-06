## Step 15: Debug service routing

```bash
kubectl describe service web-service | grep -A 3 Selector
kubectl get pods -l app=web
kubectl get endpoints web-service -o yaml
POD_IP=$(kubectl get pod -l app=web -o jsonpath='{.items[0].status.podIP}')
kubectl run direct-test --rm -it --restart=Never --image=curlimages/curl -- curl http://$POD_IP:8080
```{{exec}}

Verify selectors, endpoints, and direct pod reachability to troubleshoot routing.
