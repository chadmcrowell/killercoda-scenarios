Build and tag the container image with the command `docker build -t chadmcrowell/nginx-custom:v1 .`{{copy}}

> ⚠️ NOTE: You'll want to replace "chadmcrowell" with your Docker Hub username

List the container images with the command `docker images`{{exec}}

Login to Docker Hub with the command `docker login`{{exec}}

Push the image to Docker Hub with the command `docker push chadmcrowell/nginx-custom:v1`{{copy}}

