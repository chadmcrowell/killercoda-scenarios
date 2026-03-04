# Step 2 — Identify the Root Cause

You've confirmed something is broken. Now dig into the details to understand exactly _why_ each resource is failing.

## Diagnose the Failed Job

Describe the Job to see its status conditions and pod selector:

```bash
kubectl describe job data-processor
```{{exec}}

Look at the **Pods Statuses** line — you'll see `0 Active / 0 Succeeded / 1 Failed`. Also notice `Parallelism: 1` and `Completions: 1`, meaning the job expected exactly one successful run.

Now find the failed pod name and inspect it:

```bash
kubectl get pods -l job-name=data-processor
```{{exec}}

Describe the pod to see its exit code and last state:

```bash
kubectl describe pod -l job-name=data-processor
```{{exec}}

In the **Containers** section, look for:

```text
Last State:     Terminated
  Reason:       Error
  Exit Code:    1
```{{exec}}

Read the container logs to see the actual error message:

```bash
kubectl logs -l job-name=data-processor
```{{exec}}

You'll see:

```text
Starting data processing...
ERROR: Database connection refused on port 5432
```{{exec}}

### Root Cause #1 — `backoffLimit: 0`

```bash
kubectl get job data-processor -o jsonpath='{.spec.backoffLimit}'
```{{exec}}

The value is `0`. This means **zero retries are allowed**. The job failed once and Kubernetes marked it as permanently failed with no recovery attempt. A real data processing job needs retries to handle transient failures.

## Diagnose the Silent CronJob

Describe the CronJob in full:

```bash
kubectl describe cronjob report-generator
```{{exec}}

Look at the **Suspend** field near the top — it reads `true`. Also check **Active Jobs** (zero) and **Last Schedule** (never).

Confirm the suspension flag directly from the manifest:

```bash
kubectl get cronjob report-generator -o jsonpath='{.spec.suspend}'
```{{exec}}

Output: `true`

Check whether any job has ever been spawned by this CronJob:

```bash
kubectl get jobs -l app=report-generator
```{{exec}}

No jobs exist. The CronJob has been suspended — someone likely set `suspend: true` during maintenance and never re-enabled it.

### Root Cause #2 — `suspend: true` on the CronJob

```bash
kubectl get cronjob report-generator -o yaml | grep suspend
```{{exec}}

Output:
```yaml
suspend: true
```

The nightly reports have never run since the CronJob was created because it was deployed in a suspended state. The schedule `0 2 * * *` (2 AM daily) is correct, but the CronJob is paused.

## Summary of Findings

| Resource           | Issue             | Impact                               |
|--------------------|-------------------|--------------------------------------|
| `data-processor`   | `backoffLimit: 0` | Job fails permanently on first error |
| `report-generator` | `suspend: true`   | No jobs ever scheduled               |
