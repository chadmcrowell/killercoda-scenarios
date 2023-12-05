Notice the files `job-countdown.yaml` and `cronjob.yaml` in the current directory with the `ls -a`{{exec}} command

Open the `job-countdown.yaml` file with the command `vim job-countdown.yaml`{{exec}} to inspect it

As you can see from looking at the contents of the file, we’re using the `centos:7` image and running a `for` loop in a shell, inside the container. 

Let’s create the Kubernetes job with the command `k create -f job-countdown.yaml`{{exec}}.

Now, we can list the jobs and pods with the command command with `k get job,po`{{exec}}

Lastly, we can view the logs of the pod with the command `k logs countdown-mqd2s`{{exec}}. 

The output of these three commands will look like the following (NOTE: The name of the pod will be different for you, as the name is uniquely generated):
```bash
controlplane $ k create -f job-countdown.yaml 
job.batch/countdown created
controlplane $ k get job,po
NAME                  COMPLETIONS   DURATION   AGE
job.batch/my-job      1/1           5s         10m
job.batch/countdown   1/1           8s         10s

NAME                  READY   STATUS      RESTARTS   AGE
pod/my-job-vgjbt      0/1     Completed   0          10m
pod/countdown-mqd2s   0/1     Completed   0          10s
controlplane $ k logs countdown-mqd2s 
9
8
7
6
5
4
3
2
1
controlplane $
```