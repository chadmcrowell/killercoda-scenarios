# Graceful Pod Shutdown - SIGTERM Handling and Termination Grace Period Tuning

Welcome to the Graceful Shutdown lab. Rolling updates and pod evictions in this cluster are causing dropped connections and incomplete requests because the applications are not handling shutdown signals correctly. Your job is to configure proper termination behavior so that in-flight requests complete before pods are fully stopped.

> **Day 152 of KubeSkills Daily** — Fail Fast, Learn Faster
