# Day 85 — Job and CronJob Disasters: Batch Processing Failures

The data engineering team is reporting two separate outages:

1. A one-shot **Job** (`data-processor`) keeps entering a permanent failure state. It exits with an error on the first attempt and never retries, leaving critical records unprocessed.
2. A **CronJob** (`report-generator`) scheduled to run nightly at 2 AM has produced zero reports since it was deployed. Nobody touched it — it just silently does nothing.

In this scenario you will:

- Deploy both broken resources and observe the failure signals
- Use `kubectl describe`, `kubectl logs`, and `-o jsonpath` to pinpoint the root cause of each problem
- Fix the Job by setting a proper `backoffLimit` and correcting its command
- Unsuspend the CronJob and manually trigger it to confirm it works

Click **Start** to begin.
