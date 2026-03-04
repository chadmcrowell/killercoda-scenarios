# Service Selector Mismatch Traffic Debugging

Welcome to this service routing failure lab. An application deployment is running with all pods in Ready state, but users are reporting that the service is unreachable. Your monitoring shows the service exists and the pods are healthy, yet no traffic is getting through. Your job is to find the disconnect between the service selector and the pod labels, understand how this happened, and fix it. This is a deceptively simple failure that causes real production outages.

> **Day 92 of KubeSkills Daily** — Fail Fast, Learn Faster
