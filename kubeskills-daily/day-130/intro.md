# PersistentVolume Reclaim Policies - Data Lifecycle Management

In this lab you will explore one of the most consequential but least understood aspects of Kubernetes storage: what actually happens to your data when you delete a PVC. You have three volumes with different reclaim policies and data already written to each. Your mission is to delete each PVC, observe the outcome, understand why it happened, and then practice recovering from each scenario. This knowledge is essential for protecting production data.

> **Day 130 of KubeSkills Daily** — Fail Fast, Learn Faster
