Startup a local container registry, and push our image to that registry, so Kubernetes can pull from that local registry. 

Let’s install the local registry with the command `docker run --name local-registry -d -p 5000:5000 registry`{{copy}} 

Now, let’s give the “busy box-sleep” a new tag with the command `docker tag busybox-sleep localhost:5000/busybox-sleep`{{copy}}. 

If we run the command `docker images`, we should see an output similar to this:

```bash
controlplane $ docker images
REPOSITORY                     TAG       IMAGE ID       CREATED              SIZE
busybox-sleep                  latest    9dfaa739de5f   About a minute ago   4.26MB
localhost:5000/busybox-sleep   latest    9dfaa739de5f   About a minute ago   4.26MB
busybox                        latest    5242710cbd55   3 days ago           4.26MB
registry                       latest    4bb5ea59f8e0   2 weeks ago          24MB

```