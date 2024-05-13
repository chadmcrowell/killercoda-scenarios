Start a container registry locally with the following command:
```bash
# start a registry exposed on port 5000
docker run --name local-registry -d -p 5000:5000 registry
```{{exec}}

Re-Tag the image built in the previoius step, addressing the local registry
```bash
# re-tag the image busybox-sleep to localhost:5000/busybox-sleep
docker tag busybox-sleep localhost:5000/busybox-sleep
```{{exec}}

Push the container that you built in the previous step to the local registry
```bash
docker push localhost:5000/busybox-sleep
```{{exec}}
