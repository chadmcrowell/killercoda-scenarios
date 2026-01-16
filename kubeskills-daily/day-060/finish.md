<br>

### Reconciliation loop lessons

**Key observations**

- Status updates are required to prevent infinite reconciliation.
- Conflicting controllers fight over the same fields.
- No backoff overwhelms the API server with retries.
- Resource leaks lead to OOMKills and crash loops.
- Leader election is required for multi-replica controllers.
- Watching the wrong resources amplifies reconciliation load.

**Production patterns**

```go
func (r *AppTaskReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    log := log.FromContext(ctx)

    // Get resource
    var appTask examplev1.AppTask
    if err := r.Get(ctx, req.NamespacedName, &appTask); err != nil {
        if errors.IsNotFound(err) {
            return ctrl.Result{}, nil  // Resource deleted
        }
        return ctrl.Result{}, err
    }

    // Check if already reconciled
    if appTask.Status.ObservedGeneration == appTask.Generation {
        log.V(1).Info("Already reconciled, skipping")
        return ctrl.Result{}, nil
    }

    // Reconcile logic
    if err := r.reconcileDeployment(ctx, &appTask); err != nil {
        // Exponential backoff on error
        return ctrl.Result{RequeueAfter: 10 * time.Second}, err
    }

    // Update status
    appTask.Status.Phase = "Ready"
    appTask.Status.ObservedGeneration = appTask.Generation
    if err := r.Status().Update(ctx, &appTask); err != nil {
        return ctrl.Result{}, err
    }

    return ctrl.Result{}, nil
}
```

```go
func main() {
    mgr, err := ctrl.NewManager(ctrl.GetConfigOrDie(), ctrl.Options{
        LeaderElection:          true,
        LeaderElectionID:        "apptask-controller-lock",
        LeaderElectionNamespace: "default",
    })

    // Only leader processes events
}
```

```go
func (r *AppTaskReconciler) SetupWithManager(mgr ctrl.Manager) error {
    return ctrl.NewControllerManagedBy(mgr).
        For(&examplev1.AppTask{}).  // Watch AppTask
        Owns(&appsv1.Deployment{}). // Watch owned Deployments
        Complete(r)
}
```

```go
func (r *AppTaskReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    // ...

    if err := r.doWork(ctx); err != nil {
        // Exponential backoff
        return ctrl.Result{
            RequeueAfter: time.Duration(math.Min(
                float64(10*time.Minute),
                float64(5*time.Second)*math.Pow(2, float64(retryCount)),
            )),
        }, nil
    }

    return ctrl.Result{}, nil
}
```

**Cleanup**

```bash
kubectl delete deployment broken-controller conflicting-controller retry-bomb-controller leaky-controller no-leader-controller wrong-watch-controller working-controller crash-loop-controller
kubectl delete apptask test-apptask
kubectl delete crd apptasks.example.com
kubectl delete clusterrole broken-controller
kubectl delete clusterrolebinding broken-controller
kubectl delete serviceaccount broken-controller
```{{exec}}

---

Next: Day 61 - Helm Chart Deployment Failures (Week 9 Finale!)
