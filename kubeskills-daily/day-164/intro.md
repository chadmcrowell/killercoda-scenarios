# Persistent Volume Expansion - PVC Resize Pitfalls

A stateful application has nearly filled its persistent volume and the on-call engineer needs you to expand the PVC from 1 gigabyte to 5 gigabytes without losing any data. The storage class appears to support volume expansion but the team is unsure whether the pod will need to be restarted.

> **Day 164 of KubeSkills Daily** — Fail Fast, Learn Faster
