#!/bin/bash

# kubectl get po --field-selector spec.nodeName=controlplane -l 'app=az1-pod'

# for node in $(kubectl get nodes -l availability-zone=zone1 -ojsonpath='{.items[*].metadata.name}'); do kubectl get pods -A -owide --field-selector spec.nodeName=$node; done

kubectl get po -o wide | grep controlplane

kubectl -n 012963bd get po az1-pod