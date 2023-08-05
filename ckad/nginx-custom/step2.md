Create a Dockerfile file, which will list the instructions in order for Docker to build our container image with

Create the file with the command `vim Dockerfile`{{exec}}

Copy and paste the following into the Dockerfile:
```bash
FROM nginx:latest

COPY ./index.html /usr/share/nginx/html/index.html
```{{copy}}

