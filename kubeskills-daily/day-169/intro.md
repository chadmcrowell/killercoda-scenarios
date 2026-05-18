# Image Pull Secrets - Diagnosing Registry Authentication Failures

Private container registries require authentication, and Kubernetes uses a special secret type to store those credentials. Getting image pull secrets wrong is one of the most common causes of pods getting stuck in ImagePullBackOff or ErrImagePull. In this lab you will work through real failure scenarios to understand how secrets are referenced, how they are attached to service accounts, and how to fix credential problems quickly.

> **Day 169 of KubeSkills Daily** — Fail Fast, Learn Faster
