#!/bin/sh
set -euo pipefail

sleep 4

kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=300s
kubectl -n ingress-nginx get pods -l app.kubernetes.io/component=controller
