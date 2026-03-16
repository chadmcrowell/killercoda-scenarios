# Image Pull Secret Authentication Failures

Welcome to this lab on image pull secret failures. When pods need to pull images from private registries they rely on secrets containing registry credentials. If those secrets are missing, misnamed, or contain expired tokens the pod will fail with ErrImagePull and never start. In this lab you will diagnose the authentication failure, fix the secret, and get the deployment running.

> **Day 109 of KubeSkills Daily** — Fail Fast, Learn Faster
