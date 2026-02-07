## Step 11: Test informer/cache issues

```bash
# Conceptual: Controller without proper caching
cat > /tmp/bad-controller-example.go << 'EOF'
// Bad: Lists on every reconcile
func (r *Reconciler) Reconcile(ctx context.Context, req ctrl.Request) {
    // Lists all pods every time (expensive!)
    var pods corev1.PodList
    if err := r.List(ctx, &pods); err != nil {
        return ctrl.Result{}, err
    }
    // Process...
}

// Good: Use informer cache
func (r *Reconciler) Reconcile(ctx context.Context, req ctrl.Request) {
    // Cache automatically populated by watch
    var pods corev1.PodList
    if err := r.Client.List(ctx, &pods); err != nil { // Uses cache!
        return ctrl.Result{}, err
    }
    // Process...
}
EOF

cat /tmp/bad-controller-example.go

echo ""
echo "Informer best practices:"
echo "- Use shared informers"
echo "- Rely on watch for updates"
echo "- Don't list on every reconcile"
echo "- Use caching effectively"
```{{exec}}

Controllers should use informer caches populated by watches instead of making expensive list calls on every reconcile.
