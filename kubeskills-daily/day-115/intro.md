# ServiceAccount RBAC - Fixing API Permission Errors

Welcome to the ServiceAccount API Permissions lab. Your team has deployed a custom controller that needs to watch pod events in its namespace but the application logs are full of 403 Forbidden errors. The pod is running and the image is correct, but every attempt to call the Kubernetes API is rejected. Your task is to trace the permission chain from the pod to the service account to the role binding and fix whatever is broken.

> **Day 115 of KubeSkills Daily** — Fail Fast, Learn Faster
