#!/bin/bash
# Wait for both nodes to be ready
# kubectl wait --for=condition=Ready nodes --all --timeout=120s

# Create the namespace and deployment
kubectl create namespace trouble-node-01
kubectl create deployment api --image=nginx --replicas=5 -n trouble-node-01

# Wait for pods to be running before breaking the node
# kubectl rollout status deployment/api -n trouble-node-01 --timeout=120s

# Stop the kubelet on the worker node to simulate a failure
ssh -o StrictHostKeyChecking=no node01 "sudo systemctl stop kubelet"
