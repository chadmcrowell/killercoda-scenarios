# Step 1 — Investigate the Problem

The ops team has reported that a critical batch data-processing `Job` is failing immediately and a nightly `CronJob` for report generation has been silent for days. Your job is to deploy the broken resources and investigate what's happening.

## Deploy the Broken Resources

First, deploy the failing `Job`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: data-processor
spec:
  backoffLimit: 0
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
          echo "ERROR: Database connection refused on port 5432"
          exit 1
EOF
```

Now deploy the broken `CronJob`:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: report-generator
spec:
  schedule: "0 2 * * *"
  suspend: true
  jobTemplate:
    spec:
      backoffLimit: 2
      template:
        spec:
          restartPolicy: OnFailure
          containers:
          - name: reporter
            image: busybox:1.35
            command:
            - sh
            - -c
            - |
              echo "Generating nightly report..."
              sleep 3
              echo "Report complete."
EOF
```

## Observe the Cluster State

Wait a few seconds for the Job to attempt execution, then examine all batch resources:

```bash
kubectl get jobs
kubectl get cronjobs
kubectl get pods
```

Check cluster-wide events sorted by time to catch failure signals:

```bash
kubectl get events --sort-by=.lastTimestamp
```

You should see `data-processor` has a pod in `Error` state and that the `report-generator` CronJob shows `SUSPEND: True` with zero active runs.

## Quick Summary Check

```bash
kubectl get jobs,cronjobs,pods -o wide
```

Note the `COMPLETIONS` column on the job (it will show `0/1`) and the `ACTIVE` and `LAST SCHEDULE` columns on the CronJob (it will show `<none>` because it is suspended).
