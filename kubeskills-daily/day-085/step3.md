# Step 3 — Apply the Fix

You've identified two problems: a Job with no retries and a CronJob that is suspended. Fix both, then verify everything works correctly.

## Fix 1 — Recreate the Job with Proper Retry Settings

The original job cannot be patched in place (Job specs are mostly immutable). Delete it and redeploy with `backoffLimit: 3` and a corrected command:

```bash
kubectl delete job data-processor
```{{exec}}

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
spec:
  backoffLimit: 3
  activeDeadlineSeconds: 120
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: processor
        image: busybox:1.35
        command:
        - sh
        - -c
        - |
          echo "Starting data processing..."
          sleep 2
          echo "Processing complete. Records written: 4821"
          exit 0
EOF
```{{exec}}

Watch the Job run to completion:

```bash
kubectl get pods -l job-name=data-processor -w
```{{exec}}

Press `Ctrl+C` once the pod reaches `Completed`. Then confirm the Job succeeded:

```bash
kubectl get job data-processor
```{{exec}}

The `COMPLETIONS` column should now show `1/1`. Read the logs to verify:

```bash
kubectl logs -l job-name=data-processor
```{{exec}}

Expected output:

```text
Starting data processing...
Processing complete. Records written: 4821
```

## Fix 2 — Unsuspend the CronJob

Patch the `report-generator` CronJob to re-enable scheduling:

```bash
kubectl patch cronjob report-generator -p '{"spec":{"suspend":false}}'
```{{exec}}

Verify the suspension flag is cleared:

```bash
kubectl get cronjob report-generator
```{{exec}}

The `SUSPEND` column should now read `False`. Check the full spec to confirm:

```bash
kubectl get cronjob report-generator -o jsonpath='{.spec.suspend}{"\n"}'
```{{exec}}

Output: `false`

## Manually Trigger the CronJob to Verify It Works

The scheduled time (2 AM) won't arrive during this lab. Manually spawn a job from the CronJob template to confirm the pod runs successfully:

```bash
kubectl create job --from=cronjob/report-generator manual-report
```{{exec}}

Watch the manually-triggered job:

```bash
kubectl get pods -l job-name=manual-report -w
```{{exec}}

Press `Ctrl+C` once the pod is `Completed`. Read the output:

```bash
kubectl logs -l job-name=manual-report
```{{exec}}

Expected output:

```text
Generating nightly report...
Report complete.
```

## Final Verification

Confirm both batch resources are now healthy:

```bash
kubectl get jobs,cronjobs
```{{exec}}

Expected state:

```text
NAME                        COMPLETIONS   DURATION   AGE
job.batch/data-processor    1/1           ...        ...
job.batch/manual-report     1/1           ...        ...

NAME                              SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE
cronjob.batch/report-generator   0 2 * * *   False     0        ...
```

Both issues are resolved:

- `data-processor` completed successfully with `backoffLimit: 3` and a correct command
- `report-generator` is unsuspended and its manually-triggered job ran to completion
