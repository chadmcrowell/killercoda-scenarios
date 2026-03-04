# Namespace Resource Quota Exhaustion Debugging

Welcome to this resource quota debugging lab. An application team has filed an urgent ticket saying their deployment is not scaling up despite the cluster having plenty of node capacity. The deployment shows a desired replica count but the actual count is lower. Your job is to trace the failure chain from the deployment down to the resource quota, understand exactly which limit is being hit, and restore the ability to create new pods. This scenario is extremely common on multi-tenant clusters.

> **Day 93 of KubeSkills Daily** — Fail Fast, Learn Faster
