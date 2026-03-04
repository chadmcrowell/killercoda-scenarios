# PVC Pending Due to StorageClass Misconfiguration

Welcome to this storage debugging lab. A database deployment has been created but the pod is stuck waiting because its PersistentVolumeClaim will not bind. The storage should be available on this cluster but something is preventing the volume from being provisioned. Your job is to trace the failure chain from the pod to the PVC to the StorageClass, identify the misconfiguration, and fix it so the database can start. Storage failures are among the most impactful issues in production Kubernetes environments.

> **Day 94 of KubeSkills Daily** — Fail Fast, Learn Faster
