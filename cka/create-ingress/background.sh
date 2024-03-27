kubectl create deploy apache --image httpd

kubectl expose deploy apache --name apache-svc --port 80