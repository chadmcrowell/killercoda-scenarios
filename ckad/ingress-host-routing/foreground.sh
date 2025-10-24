#!/bin/sh

#  _  _                     _                  _            
# | || |   ___    __ _   __| |   ___   ___    | |_    ___   
# | || |_ / _ \  / _` | / _` |  / _ \ / __|   | __|  / _ \  
# |__   _| (_) || (_| || (_| | |  __/ \__ \   | |_  | (_) | 
#    |_|  \___/  \__,_| \__,_|  \___| |___/    \__|  \___/  
#                                                            
# Let the ingress gatekeeper get into position before the lab begins.

# Kick the tires: ensure the ingress-nginx manifest is applied (idempotent).
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Give the controller a couple of seconds to spin up before we start nagging it.
sleep 4

# Hold the door open until the controller reports a healthy rollout.
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=300s

# Show the pods so learners know the gatekeeper is on duty.
kubectl -n ingress-nginx get pods -l app.kubernetes.io/component=controller
