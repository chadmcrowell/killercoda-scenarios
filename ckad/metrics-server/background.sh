# Install Metrics Server

kubectl apply -f https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_02/metrics-server-components.yaml

# create pods

kubectl apply -f https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_02/pod-php-apache.yaml

kubectl apply -f https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_02/pod-emptydir-two-containers-full.yaml

kubectl apply -f https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_02/pod-hostpath.yaml