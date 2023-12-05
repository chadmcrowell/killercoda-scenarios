Now, let's open the `job-countdown.yaml` file with the command `vim job-countdown.yaml`{{exec}} to inspect it.

As you can see from the cronJob YAML, we are creating a job to print the date every minute on a cron schedule. 

If we wait a few minutes, we can see that multiple jobs are created, as well as a pod for each job. To see this, we can type the command `k get cj,job,po`{{exec}}

The output will look similar to this:
```bash
controlplane $ k get cj,job,po
NAME                   SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/my-job   */1 * * * *   False     0        22s             5m9s

NAME                        COMPLETIONS   DURATION   AGE
job.batch/my-job            1/1           5s         48m
job.batch/countdown         1/1           8s         38m
job.batch/my-job-28176066   1/1           3s         2m22s
job.batch/my-job-28176067   1/1           4s         82s
job.batch/my-job-28176068   1/1           4s         22s

NAME                        READY   STATUS      RESTARTS   AGE
pod/my-job-vgjbt            0/1     Completed   0          48m
pod/countdown-mqd2s         0/1     Completed   0          38m
pod/my-job-28176066-l9fvs   0/1     Completed   0          2m22s
pod/my-job-28176067-4xl47   0/1     Completed   0          82s
pod/my-job-28176068-gr2c8   0/1     Completed   0          22s
```