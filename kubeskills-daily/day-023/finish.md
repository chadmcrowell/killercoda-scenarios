<br>

### CNI failures understood

**Key observations**

✅ CNI assigns pod IPs; without it pods stall in ContainerCreating.  
✅ NetworkPolicies only work if the CNI supports them.  
✅ DNS relies on pod network plumbing; dnsPolicy changes resolv.conf.  
✅ MTU mismatches drop large packets; match interface MTUs.  
✅ Pod CIDR exhaustion breaks IP allocation and pod startup.

**Production patterns**

Check CNI health:

```bash
kubectl get pods -n kube-system -l k8s-app=cilium  # or calico-node, flannel
kubectl logs -n kube-system <cni-pod-name>
```

Test connectivity across nodes:

```bash
kubectl run test-source --image=nicolaka/netshoot --command -- sleep 3600
kubectl run test-dest --image=nginx
kubectl exec test-source -- curl <pod-ip>
```

Monitor for errors:

```bash
kubectl logs -n kube-system -l app=calico-node --tail=100 | grep -i error
```

Backup CNI configuration:

```bash
kubectl get -n kube-system configmap cni-config -o yaml > cni-backup.yaml
```

**Cleanup**

```bash
kubectl delete networkpolicy deny-all 2>/dev/null
kubectl delete pod nettest-1 nettest-2 host-network-pod dns-default dns-clusterfirst dns-none cni-debug 2>/dev/null
kubectl delete deployment ip-hungry 2>/dev/null
kubectl delete service nettest-svc 2>/dev/null
```{{exec}}

---

Next: Day 24 - kube-proxy Modes and Service Routing
