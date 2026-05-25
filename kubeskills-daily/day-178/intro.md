# Kubernetes Garbage Collection - Cleaning Up Orphaned and Stale Resources

Your cluster has been running for over a year and etcd is growing faster than expected. An initial audit reveals hundreds of completed Job pods, dozens of old ReplicaSet objects, and a collection of PersistentVolumeClaims that are bound to volumes that no longer exist. You need to clean up these orphaned resources, configure limits to prevent future accumulation, and verify the overall resource count drops significantly.

> **Day 178 of KubeSkills Daily** — Fail Fast, Learn Faster
