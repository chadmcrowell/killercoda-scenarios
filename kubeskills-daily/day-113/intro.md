# QoS Classes and Kubelet Eviction Ordering

Welcome to the QoS and Eviction lab. Your cluster has experienced several unexpected pod restarts during peak traffic and the root cause appears to be kubelet eviction under memory pressure. Some of the evicted pods were critical services that should have survived while less important batch jobs were killed first. Your task is to understand why the eviction order was wrong and fix the resource configurations to protect the right workloads.

> **Day 113 of KubeSkills Daily** — Fail Fast, Learn Faster
