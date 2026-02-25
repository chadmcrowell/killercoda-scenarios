wget https://raw.githubusercontent.com/chadmcrowell/k8s/refs/heads/main/manifests/pod-data-processor.yaml

kubectl create ns production

kubectl label node node01 disk=ssd

kubectl label node node01 zone=west
