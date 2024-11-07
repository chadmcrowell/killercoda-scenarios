Notice the Dockerfile in the current directory with the `ls -a`{{exec}} command

Open the `Dockerfile` with the `vim Dockerfile`{{exec}} command

The first line is the `FROM` instruction. This specifies the Parent Image from which you are building. 

The second line is `ENTRYPOINT` instruction. The `ENTRYPOINT` instruction will allow you to run an executable (e.g. “sleep”) immediately as the container is starting up. 

The third line is `CMD`, which is passed to the `ENTRYPOINT` as a command parameter (e.g. “3600”). 

In this case, the command parameter is “3600” which is in seconds (i.e. 1 hour). 

So these lines would be similar to running the command `sleep 3600` from a shell within the container. 

We can exit vim to get back to our command line prompt. Let’s now run the command `docker build -t busybox-sleep .` to build a container image from that `Dockerfile` and tag it with the `-t` option and “busybox-sleep”. 

You will see that the output look similar to the following:

```bash
controlplane $ docker build -t busybox-sleep .
Sending build context to Docker daemon  6.711MB
Step 1/3 : FROM busybox
latest: Pulling from library/busybox
71d064a1ac7d: Pull complete 
Digest: sha256:6e494387c901caf429c1bf77bd92fb82b33a68c0e19f6d1aa6a3ac8d27a7049d
Status: Downloaded newer image for busybox:latest
 ---> b539af69bc01
Step 2/3 : ENTRYPOINT ["sleep"]
 ---> Running in 27bf6efb18dc
Removing intermediate container 27bf6efb18dc
 ---> 55de7efd5d0b
Step 3/3 : CMD ["3600"]
 ---> Running in 2783a599fba1
Removing intermediate container 2783a599fba1
 ---> aa92909e7707
Successfully built aa92909e7707
Successfully tagged busybox-sleep:latest

```