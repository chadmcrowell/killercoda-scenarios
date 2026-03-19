#!/bin/bash

# Install Metrics Server
kubectl apply -f https://raw.githubusercontent.com/chadmcrowell/acing-the-ckad-exam/main/ch_02/metrics-server-components.yaml

# Stop the kubelet on the worker node to simulate a failure
ssh -o StrictHostKeyChecking=no node01 "sudo systemctl stop kubelet"

# Wait for node01 to transition to NotReady before creating workloads
# so that pods are born into an unschedulable state and generate FailedScheduling events
kubectl wait --for=condition=Ready=False node/node01 --timeout=120s

# Create the namespace and deployment (pods will be stuck in Pending)
kubectl create namespace trouble-node-01
kubectl create deployment api --image=nginx --replicas=5 -n trouble-node-01
