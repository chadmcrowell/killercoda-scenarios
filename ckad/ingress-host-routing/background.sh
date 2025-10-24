#!/bin/sh
set -euo pipefail

MANIFEST="https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml"

kubectl get namespace ingress-nginx >/dev/null 2>&1 || \
  kubectl apply -f "$MANIFEST"

kubectl apply -f "$MANIFEST"

kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=300s
