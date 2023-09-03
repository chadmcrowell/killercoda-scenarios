Create a deployment from your new customer nginx container image with the command `k create deploy custom-nginx --image chadmcrowell/nginx-custom:v1`{{copy}}

List the deployments and pods in your Kubernetes cluster with the command `k get deploy,po`{{exec}}

Create the service that will make the deployment available from the web with the command `k expose deploy custom-nginx --type=NodePort --port=80 --name=nginx-service`{{exec}}

List the services in your cluster with the command `k get svc`{{exec}}

Copy the NodePort number (e.g. 31221) in the "PORT(S)" column (the number next to 80)

To view your new nginx web page, click on the hamburger menu in the upper right corner (below "Logout"), and select "Traffic / Ports".

Under "Custom Ports" paste in the node port that you copied from the service named "nginx-service"