## Step 3: Test stable network identity

```bash
for i in 0 1 2; do
  echo "Testing DNS for web-$i:"
  kubectl run dns-test-$i --rm -i --image=busybox --restart=Never -- \
    nslookup web-$i.nginx-headless.default.svc.cluster.local
done

echo ""
echo "Stable DNS format:"
echo "pod-name.service-name.namespace.svc.cluster.local"
```{{exec}}

Each StatefulSet pod gets a stable DNS entry via the headless service. The format `pod-name.service-name.namespace.svc.cluster.local` persists even across pod restarts.
