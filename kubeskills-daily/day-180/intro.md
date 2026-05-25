# Image Pull Secrets - Diagnosing and Fixing Registry Credential Failures

Your on-call team has been paged because several workloads across different namespaces are failing with ImagePullBackOff. Initial investigation shows all of these pods are trying to pull from the same private container registry, but the credential setup is different in each namespace. You need to diagnose the specific credential problem in each case and apply the appropriate fix without disrupting other running workloads.

> **Day 180 of KubeSkills Daily** — Fail Fast, Learn Faster
