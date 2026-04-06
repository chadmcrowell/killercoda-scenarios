# Kubernetes Version Upgrades - Safe Control Plane Upgrade Procedure

Welcome to the cluster upgrade lab. Your cluster is running an older version of Kubernetes and needs to be upgraded to the next minor version. Before you can safely upgrade there are deprecated API versions in use by existing workloads that will break after the upgrade if not addressed. Your job is to audit the cluster for compatibility issues, fix them, and then execute the full upgrade sequence correctly using kubeadm.

> **Day 131 of KubeSkills Daily** — Fail Fast, Learn Faster
