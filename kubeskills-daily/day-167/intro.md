# etcd Compaction and Defragmentation

etcd is the distributed key-value store that backs all Kubernetes cluster state. Every time a resource is created, updated, or deleted, etcd stores a new revision. Without periodic compaction to remove old revisions and defragmentation to reclaim fragmented space, the etcd database grows continuously. In this lab you will learn how to identify etcd growth issues and apply the maintenance operations needed to keep it healthy.

> **Day 167 of KubeSkills Daily** — Fail Fast, Learn Faster
