Notice the Dockerfile in the current directory with the `ls -a`{{exec}} command

To view the Dockerfile, open with the command `vim Dockerfile`{{exec}}

To build the container image using the Dockerfile, use the following command:
```bash
# build the container image from a file named Dockerfile in the current directory
docker build -t busybox-sleep .
```{{exec}}

List the images with the command `docker images`{{exec}}

