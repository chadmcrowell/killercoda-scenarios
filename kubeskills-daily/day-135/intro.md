# Missing Resource Requests - Silent Node Starvation

The application team deployed several microservices quickly without setting resource requests or limits. The cluster appeared healthy but during a recent load test the node became unresponsive and several pods were evicted unexpectedly. Your task is to investigate the resource configuration of these workloads and fix them before the next traffic event.

> **Day 135 of KubeSkills Daily** — Fail Fast, Learn Faster
