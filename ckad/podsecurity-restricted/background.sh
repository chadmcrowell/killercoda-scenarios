#!/bin/sh

# Prepare the lab environment before the learner starts.
set -euo pipefail

NAMESPACE="session283884"
DEPLOYMENT="demo-app"

kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1 || \
kubectl create namespace "${NAMESPACE}"

