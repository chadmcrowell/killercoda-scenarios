<br>

### Service routing decoded

**Key observations**

✅ kube-proxy modes: iptables (default), ipvs (scales better), userspace (legacy).  
✅ ClusterIP is virtual; endpoints must exist for traffic to flow.  
✅ iptables rules scale with service/endpoints count and can be heavy.  
✅ NodePort exposes via node IP/port; externalTrafficPolicy=Local preserves source IP.  
✅ Session affinity ClientIP sticks traffic to one backend.

**Production patterns**

Check kube-proxy health:

```bash
kubectl get pods -n kube-system -l k8s-app=kube-proxy
kubectl logs -n kube-system -l k8s-app=kube-proxy --tail=100
```

Monitor service endpoints:

```bash
kubectl get endpoints -A | awk '$2 == "<none>" {print $1, $2}'
```

Switch to IPVS for scale:

```yaml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  scheduler: "rr"
```

Preserve source IPs:

```yaml
apiVersion: v1
kind: Service
spec:
  type: LoadBalancer
  externalTrafficPolicy: Local
```

**Cleanup**

```bash
kubectl delete deployment web-backend test-{1..10} 2>/dev/null
kubectl delete service web-service no-endpoints-svc web-nodeport sticky-service web-external web-lb test-{1..10} 2>/dev/null
kubectl delete pod iptables-viewer 2>/dev/null
```{{exec}}

---

Next: Day 25 - etcd Performance and Cluster Stability
