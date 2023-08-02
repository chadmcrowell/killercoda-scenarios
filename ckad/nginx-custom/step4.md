Create a deployment from your new customer nginx container image with the command `k create deploy custom-nginx --image chadmcrowell/nginx-custom:v1`{{copy}}

List the deployments and pods in your Kubernetes cluster with the command `k get deploy,po`{{exec}}

Create the service that will make the deployment available from the web with the command `k expose deploy custom --type=NodePort --port=80 --name=nginx-service`{{exec}}

List the services in your cluster with the command `k get svc`{{exec}}

To view your new nginx web page, click on the hamburger menu in the upper right corner (below "Logout"), and select "Traffic / Ports".

Under "Common Ports" select the "80" button