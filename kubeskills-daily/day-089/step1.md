# Investigate the Problem

Week 14, Day 89: Node Affinity - Scheduling Where You Want
Subject: Day 89: Your pods keep landing on the wrong nodes

```bash
kubectl get pods -A
kubectl get events --sort-by=.lastTimestamp
```