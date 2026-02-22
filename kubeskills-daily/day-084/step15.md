## Step 15: Ingress troubleshooting guide

```bash
cat > /tmp/ingress-troubleshooting.md << 'EOF'
# Ingress Troubleshooting Guide

## Diagnosis Steps

### 1. Check Ingress Controller
kubectl get pods -A | grep ingress
kubectl logs -n <namespace> <ingress-controller-pod>
kubectl get svc -A | grep ingress

Common issues:
- Controller not installed
- Controller crashed
- Controller missing RBAC permissions

### 2. Check IngressClass
kubectl get ingressclass
kubectl get ingress <name> -o jsonpath='{.spec.ingressClassName}'

Common issues:
- No IngressClass defined
- Wrong IngressClass in Ingress spec
- Multiple default IngressClasses

### 3. Verify Ingress Resource
kubectl get ingress <name>             # ADDRESS should be populated
kubectl describe ingress <name>        # Check Events section
kubectl get ingress <name> -o yaml     # Full spec

Look for: populated ADDRESS, correct backend service names,
valid TLS secret names, proper path configuration.

### 4. Test Backend Service
kubectl get svc <service-name>
kubectl get endpoints <service-name>
kubectl run test --rm -i --image=busybox -- wget -O- <service-name>

Common issues:
- Service doesn't exist
- Service has no endpoints (no pods match selector)
- Service port wrong, pods not ready

### 5. Test TLS Configuration
kubectl get secret <tls-secret> -o jsonpath='{.type}'
kubectl get secret <tls-secret> -o jsonpath='{.data.tls\.crt}' | \
  base64 -d | openssl x509 -enddate -noout

Common issues:
- Secret type not kubernetes.io/tls
- Certificate expired or doesn't match hostname
- Secret in wrong namespace

### 6. Test External Access
INGRESS_IP=$(kubectl get ingress <name> -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -H "Host: example.com" http://$INGRESS_IP/path
curl -k -H "Host: example.com" https://$INGRESS_IP/path

## Problem: 404 Not Found

Causes:
- Wrong path in Ingress
- PathType mismatch (Exact vs Prefix)
- Service name typo
- Host header doesn't match

Debug:
kubectl get ingress <name> -o yaml | grep -A 10 paths
curl -v -H "Host: example.com" http://$INGRESS_IP/

## Problem: 503 Service Unavailable

Causes:
- Service has no endpoints
- All pods not ready
- Rate limit exceeded

Debug:
kubectl get endpoints <service-name>
kubectl get pods -l <selector>

## Problem: TLS/SSL Errors

Causes:
- Certificate doesn't match hostname
- Certificate expired
- Secret not found or wrong type

Debug:
openssl s_client -connect $INGRESS_IP:443 -servername example.com
kubectl get secret <tls-secret> -o yaml

## Problem: Ingress Not Getting IP

Causes:
- Ingress controller not running
- Wrong IngressClass
- Cloud provider issue for LoadBalancer type

Debug:
kubectl get pods -A | grep ingress
kubectl get ingressclass
kubectl logs -n ingress-nginx <controller-pod>

## Path Type Reference

Exact:   /foo     matches /foo only
         /foo/    does NOT match
         /foo/bar does NOT match

Prefix:  /foo     matches /foo, /foo/, /foo/bar
         /        matches everything

ImplementationSpecific: controller-dependent, required for regex rewrites

## Production Best Practices

- Consolidate rules for the same host in one Ingress
- Always specify ingressClassName explicitly
- Keep TLS Secrets in the same namespace as the Ingress
- Use cert-manager for automatic TLS certificate management
- Set appropriate timeouts with proxy-connect/send/read-timeout annotations
- Add security headers via configuration-snippet
- Monitor with nginx_ingress_controller_requests and nginx_ingress_controller_backend_up metrics

## Key Alerts

StatefulSet replica mismatch:
  kube_statefulset_status_replicas_ready != kube_statefulset_replicas

High Ingress error rate:
  sum(rate(requests{status=~"5.."}[5m])) / sum(rate(requests[5m])) > 0.05

TLS certificate expiring:
  (nginx_ingress_controller_ssl_expire_time_seconds - time()) / 86400 < 30
EOF

cat /tmp/ingress-troubleshooting.md
```{{exec}}

A systematic troubleshooting guide covering the four most common Ingress failure patterns, path type semantics, and production best practices for reliable traffic routing.
