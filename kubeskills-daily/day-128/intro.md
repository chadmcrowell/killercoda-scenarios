# etcd Backup and Restore - Full Cluster Recovery Practice

This lab walks you through the complete etcd disaster recovery procedure. You will start by taking a snapshot of your cluster's etcd data while everything is healthy. Then you will delete some important workloads to simulate an accidental mass deletion event. Finally you will restore your cluster from the snapshot and verify that the deleted workloads are back. This skill is critical for the CKA exam and for any production Kubernetes operator.

> **Day 128 of KubeSkills Daily** — Fail Fast, Learn Faster
