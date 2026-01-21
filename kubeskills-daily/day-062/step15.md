## Step 15: Diagnose CNI issues

```bash
cat > /tmp/cni-diagnosis.sh << 'EOF'
#!/bin/bash
echo "=== CNI Diagnosis Report ==="

echo -e "\n1. Pod Networking Status:"
kubectl get pods -A -o wide | grep -E "ContainerCreating|Error|CrashLoopBackOff" | head -10

echo -e "\n2. Pod CIDR Configuration:"
kubectl get nodes -o custom-columns=NAME:.metadata.name,CIDR:.spec.podCIDR

echo -e "\n3. CNI Pods Status:"
kubectl get pods -n kube-system -l k8s-app=kube-proxy -o wide 2>/dev/null || echo "kube-proxy pods not found"

echo -e "\n4. Network Policy Resources:"
kubectl get networkpolicies -A

echo -e "\n5. Service CIDR:"
kubectl cluster-info dump | grep -m 1 service-cluster-ip-range || echo "Service CIDR not found"

echo -e "\n6. Recent Pod Events (network-related):"
kubectl get events -A --sort-by='.lastTimestamp' | grep -i "network\|cni\|sandbox" | tail -10

echo -e "\n7. Pod IP Assignment:"
kubectl get pods -A -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,IP:.status.podIP,NODE:.spec.nodeName | grep -v "IP.*<none>" | head -10

echo -e "\n8. Common CNI Issues:"
echo "   - IP exhaustion: Too many pods for pod CIDR"
echo "   - CNI plugin crash: Pods stuck in ContainerCreating"
echo "   - Config corruption: Network setup fails"
echo "   - Cross-node routing: Pods can't reach other nodes"
echo "   - NetworkPolicy: Requires CNI plugin support"
EOF

chmod +x /tmp/cni-diagnosis.sh
/tmp/cni-diagnosis.sh
```{{exec}}

Run a quick CNI diagnosis script to summarize cluster state.
