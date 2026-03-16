# Cluster Autoscaler Scale-Up Failures

Welcome to this lab on cluster autoscaler failures. The cluster autoscaler is supposed to automatically add nodes when pods cannot be scheduled due to resource constraints. However there are several common reasons why the autoscaler stays silent even when pods are clearly stuck Pending. In this lab you will trace the failure through autoscaler logs and pod specs and apply the fixes needed to restore automatic scaling.

> **Day 110 of KubeSkills Daily** — Fail Fast, Learn Faster
