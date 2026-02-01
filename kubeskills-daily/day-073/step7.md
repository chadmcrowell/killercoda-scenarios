## Step 7: Apply NetworkPolicy isolation

```bash
# Save ClusterIP for later test
WEB_B_IP=$(kubectl get svc web -n team-b -o jsonpath='{.spec.clusterIP}')

# Block all cross-namespace traffic
for tenant in team-a team-b team-c; do
  cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-other-namespaces
  namespace: $tenant
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          tenant: $tenant
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          tenant: $tenant
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
EOF
done

# Test connectivity after NetworkPolicy
kubectl run test2 -n team-a --rm -it --image=busybox --restart=Never -- \
  wget -O- --timeout=2 http://$WEB_B_IP 2>&1 || echo "Blocked by NetworkPolicy!"
```{{exec}}

NetworkPolicy blocks cross-namespace pod communication.
